import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/archive_project_use_case.dart';
import '../../domain/usecases/delete_project_use_case.dart';
import '../../domain/usecases/get_projects_use_case.dart';
import '../../domain/usecases/update_project_use_case.dart';

enum ProjectsListStatus { initial, loading, success, failure }

class ProjectsListState extends Equatable {
  final ProjectsListStatus status;
  final List<ProjectEntity> projects;
  final List<ProjectEntity> filteredProjects;
  final String searchQuery;
  final String? errorMessage;

  const ProjectsListState({
    this.status = ProjectsListStatus.initial,
    this.projects = const [],
    this.filteredProjects = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  ProjectsListState copyWith({
    ProjectsListStatus? status,
    List<ProjectEntity>? projects,
    List<ProjectEntity>? filteredProjects,
    String? searchQuery,
    String? errorMessage,
  }) {
    final newProjects = projects ?? this.projects;
    final query = searchQuery ?? this.searchQuery;
    final newFiltered = query.isEmpty
        ? newProjects
        : newProjects.where((p) {
            return p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.projectId.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ProjectsListState(
      status: status ?? this.status,
      projects: newProjects,
      filteredProjects: newFiltered,
      searchQuery: query,
      errorMessage: errorMessage,
    );
  }

  ProjectsListState addProjectLocal(ProjectEntity newProject) {
    final updated = [newProject, ...projects];
    return copyWith(status: ProjectsListStatus.success, projects: updated);
  }

  ProjectsListState removeProjectLocal(String projectId) {
    final updated = projects.where((p) => p.id != projectId).toList();
    return copyWith(status: ProjectsListStatus.success, projects: updated);
  }

  @override
  List<Object?> get props => [
    status,
    projects,
    filteredProjects,
    searchQuery,
    errorMessage,
  ];
}

class ProjectsListCubit extends Cubit<ProjectsListState> {
  final GetProjectsUseCase _getProjectsUseCase;
  final ArchiveProjectUseCase _archiveProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;

  ProjectsListCubit({
    required this._getProjectsUseCase,
    required this._archiveProjectUseCase,
    required this._deleteProjectUseCase,
    required this._updateProjectUseCase,
  }) : super(const ProjectsListState());

  Future<void> loadProjects() async {
    emit(state.copyWith(status: ProjectsListStatus.loading));
    final result = await _getProjectsUseCase(params: const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProjectsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (projects) => emit(
        state.copyWith(status: ProjectsListStatus.success, projects: projects),
      ),
    );
  }

  void searchProjects(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void addProjectLocally(ProjectEntity project) {
    emit(state.addProjectLocal(project));
  }

  Future<void> archiveProject(String id) async {
    final result = await _archiveProjectUseCase(
      params: ArchiveProjectParams(id: id),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedProjects = state.projects.map((p) {
          if (p.id == id) {
            return p.copyWith(isArchived: true);
          }
          return p;
        }).toList();
        emit(state.copyWith(projects: updatedProjects));
      },
    );
  }

  Future<void> deleteProject(String id) async {
    final result = await _deleteProjectUseCase(
      params: DeleteProjectParams(id: id),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.removeProjectLocal(id)),
    );
  }

  Future<void> toggleFavorite(ProjectEntity project) async {
    final updatedProject = project.copyWith(isFavorite: !project.isFavorite);

    // Optimistic UI update
    final updatedProjects = state.projects.map((p) {
      if (p.id == project.id) {
        return updatedProject;
      }
      return p;
    }).toList();
    emit(state.copyWith(projects: updatedProjects));

    // Save to repository
    final result = await _updateProjectUseCase(
      params: UpdateProjectParams(project: updatedProject),
    );
    result.fold((failure) {
      // Revert on failure
      final revertedProjects = state.projects.map((p) {
        if (p.id == project.id) {
          return project;
        }
        return p;
      }).toList();
      emit(
        state.copyWith(
          projects: revertedProjects,
          errorMessage: failure.message,
        ),
      );
    }, (_) => null);
  }
}
