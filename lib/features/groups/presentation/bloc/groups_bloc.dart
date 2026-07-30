import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/usecases/add_group_members.dart';
import 'package:issues_tracking/features/groups/domain/usecases/add_group_projects.dart';
import 'package:issues_tracking/features/groups/domain/usecases/assign_role.dart';
import 'package:issues_tracking/features/groups/domain/usecases/create_group.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_group_by_id.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_groups.dart';
import 'package:issues_tracking/features/groups/domain/usecases/update_group.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GetGroups getGroups;
  final CreateGroup createGroup;
  final AssignRole assignRole;
  final GetGroupById getGroupById;
  final AddGroupMembers addGroupMembers;
  final AddGroupProjects addGroupProjects;
  final UpdateGroup updateGroup;

  GroupsBloc({
    required this.getGroups,
    required this.createGroup,
    required this.assignRole,
    required this.getGroupById,
    required this.addGroupMembers,
    required this.addGroupProjects,
    required this.updateGroup,
  }) : super(GroupsInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<SelectGroup>(_onSelectGroup);
    on<CreateGroupEvent>(_onCreateGroup);
    on<AssignRoleEvent>(_onAssignRole);
    on<AddGroupMembersEvent>(_onAddGroupMembers);
    on<AddGroupProjectsEvent>(_onAddGroupProjects);
    on<UpdateGroupSettingsEvent>(_onUpdateGroupSettings);
  }

  Future<void> _onLoadGroups(
    LoadGroups event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading());
    final result = await getGroups(params: const NoParams());
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (groups) => emit(GroupsLoaded(groups: groups)),
    );
  }

  Future<void> _onSelectGroup(
    SelectGroup event,
    Emitter<GroupsState> emit,
  ) async {
    if (state is GroupsLoaded) {
      final current = state as GroupsLoaded;
      emit(
        current.copyWith(
          selectedGroupId: event.groupId,
          clearSelected: event.groupId == null,
        ),
      );
    }
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await createGroup(
      params: CreateGroupParams(
        name: event.name,
        description: event.description,
      ),
    );
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (_) => add(const LoadGroups()),
    );
  }

  Future<void> _onAssignRole(
    AssignRoleEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await assignRole(
      params: AssignRoleParams(
        groupId: event.groupId,
        roleName: event.roleName,
        projectId: event.projectId,
      ),
    );
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (_) => _refreshGroup(event.groupId, emit),
    );
  }

  Future<void> _onAddGroupMembers(
    AddGroupMembersEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await addGroupMembers(
      params: AddGroupMembersParams(
        groupId: event.groupId,
        userIds: event.userIds,
      ),
    );
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (_) => _refreshGroup(event.groupId, emit),
    );
  }

  Future<void> _onAddGroupProjects(
    AddGroupProjectsEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await addGroupProjects(
      params: AddGroupProjectsParams(
        groupId: event.groupId,
        projectIds: event.projectIds,
      ),
    );
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (_) => _refreshGroup(event.groupId, emit),
    );
  }

  Future<void> _onUpdateGroupSettings(
    UpdateGroupSettingsEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await updateGroup(
      params: UpdateGroupParams(
        id: event.groupId,
        name: event.name,
        description: event.description,
        autoJoin: event.autoJoin,
        autoJoinDomains: event.autoJoinDomains,
        twoFactorAuth: event.twoFactorAuth,
        groupType: event.groupType,
        logo: event.logo,
      ),
    );
    result.fold(
      (failure) => emit(GroupsError(failure.message)),
      (_) => _refreshGroup(event.groupId, emit),
    );
  }

  Future<void> _refreshGroup(
    String groupId,
    Emitter<GroupsState> emit,
  ) async {
    if (state is! GroupsLoaded) return;
    final result = await getGroupById(
      params: GetGroupByIdParams(id: groupId),
    );
    result.fold((failure) => null, (updated) {
      if (state is! GroupsLoaded) return;
      final current = state as GroupsLoaded;
      final updatedGroups = current.groups.map((g) {
        return g.id == groupId ? updated : g;
      }).toList();
      emit(current.copyWith(groups: updatedGroups));
    });
  }
}
