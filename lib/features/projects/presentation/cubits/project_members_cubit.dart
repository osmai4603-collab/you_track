import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/project_member_entity.dart';
import '../../domain/usecases/add_project_member_use_case.dart';
import '../../domain/usecases/get_project_members_use_case.dart';

enum ProjectMembersStatus { initial, loading, success, failure }

class ProjectMembersState extends Equatable {
  final ProjectMembersStatus status;
  final List<ProjectMemberEntity> members;
  final String? errorMessage;
  final String searchQuery;

  const ProjectMembersState({
    this.status = ProjectMembersStatus.initial,
    this.members = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  ProjectMembersState copyWith({
    ProjectMembersStatus? status,
    List<ProjectMemberEntity>? members,
    String? errorMessage,
    String? searchQuery,
  }) {
    return ProjectMembersState(
      status: status ?? this.status,
      members: members ?? this.members,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  ProjectMembersState addMemberLocal(ProjectMemberEntity member) {
    return copyWith(
      status: ProjectMembersStatus.success,
      members: [...members, member],
    );
  }

  @override
  List<Object?> get props => [status, members, errorMessage, searchQuery];
}

class ProjectMembersCubit extends Cubit<ProjectMembersState> {
  final GetProjectMembersUseCase _getProjectMembersUseCase;
  final AddProjectMemberUseCase _addProjectMemberUseCase;

  ProjectMembersCubit({
    required GetProjectMembersUseCase getProjectMembersUseCase,
    required AddProjectMemberUseCase addProjectMemberUseCase,
  }) : _getProjectMembersUseCase = getProjectMembersUseCase,
       _addProjectMemberUseCase = addProjectMemberUseCase,
       super(const ProjectMembersState());

  Future<void> loadMembers(String projectId) async {
    emit(state.copyWith(status: ProjectMembersStatus.loading));
    final result = await _getProjectMembersUseCase(
      params: GetProjectMembersParams(projectId: projectId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProjectMembersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (members) => emit(
        state.copyWith(status: ProjectMembersStatus.success, members: members),
      ),
    );
  }

  Future<void> addMember({
    required String projectId,
    required String name,
    required String email,
    required String userId,
    required List<String> roles,
  }) async {
    final newMember = ProjectMemberEntity(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      // name: name,
      // email: email,
      roles: roles,
      userId: userId,
    );
    final result = await _addProjectMemberUseCase(
      params: AddProjectMemberParams(member: newMember),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (added) => emit(state.addMemberLocal(added)),
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
