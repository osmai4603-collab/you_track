import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/get_project_by_id_use_case.dart';

enum ProjectDetailsStatus { initial, loading, success, failure }

class ProjectDetailsState extends Equatable {
  final ProjectDetailsStatus status;
  final ProjectEntity? project;
  final int activeTabIndex;
  final String searchQuery;
  final String? errorMessage;

  const ProjectDetailsState({
    this.status = ProjectDetailsStatus.initial,
    this.project,
    this.activeTabIndex = 0,
    this.searchQuery = '',
    this.errorMessage,
  });

  ProjectDetailsState copyWith({
    ProjectDetailsStatus? status,
    ProjectEntity? project,
    int? activeTabIndex,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ProjectDetailsState(
      status: status ?? this.status,
      project: project ?? this.project,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, project, activeTabIndex, searchQuery, errorMessage];
}

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final GetProjectByIdUseCase _getProjectByIdUseCase;

  ProjectDetailsCubit({
    required GetProjectByIdUseCase getProjectByIdUseCase,
  })  : _getProjectByIdUseCase = getProjectByIdUseCase,
        super(const ProjectDetailsState());

  Future<void> loadProject(String idOrKey) async {
    emit(state.copyWith(status: ProjectDetailsStatus.loading));
    final result = await _getProjectByIdUseCase(params: GetProjectByIdParams(id: idOrKey));
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProjectDetailsStatus.failure,
        errorMessage: failure.message,
      )),
      (project) => emit(state.copyWith(
        status: ProjectDetailsStatus.success,
        project: project,
      )),
    );
  }

  void changeTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }

  void searchIssues(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
