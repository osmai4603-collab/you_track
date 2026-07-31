import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/usecases/add_group_members.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_group_members.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_groups.dart';
import 'package:issues_tracking/features/groups/domain/usecases/remove_group_members.dart';
import 'package:issues_tracking/features/users/domain/usecases/ban_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/create_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/delete_user.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';
import 'package:issues_tracking/features/users/domain/usecases/merge_users.dart';
import 'package:issues_tracking/features/users/domain/usecases/update_user.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;
  final CreateUser createUser;
  final DeleteUser deleteUser;
  final BanUser banUser;
  final UpdateUser updateUser;
  final MergeUsers mergeUsers;
  final AddGroupMembers addGroupMembers;
  final RemoveGroupMembers removeGroupMembers;
  final GetGroups getGroups;
  final GetGroupMembers getGroupMembers;

  UsersBloc({
    required this.getUsers,
    required this.createUser,
    required this.deleteUser,
    required this.banUser,
    required this.updateUser,
    required this.mergeUsers,
    required this.addGroupMembers,
    required this.removeGroupMembers,
    required this.getGroups,
    required this.getGroupMembers,
  }) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SelectUser>(_onSelectUser);
    on<CreateUserEvent>(_onCreateUser);
    on<InviteUsersEvent>(_onInviteUsers);
    on<ToggleUserSelection>(_onToggleUserSelection);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<ClearSelection>(_onClearSelection);
    on<DeleteUsersEvent>(_onDeleteUsers);
    on<BanUsersEvent>(_onBanUsers);
    on<EditUserEvent>(_onEditUser);
    on<MergeUsersEvent>(_onMergeUsers);
    on<AddUsersToGroupEvent>(_onAddUsersToGroup);
    on<RemoveUsersFromGroupEvent>(_onRemoveUsersFromGroup);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getUsers(params: const NoParams());
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }

  Future<void> _onSelectUser(
    SelectUser event,
    Emitter<UsersState> emit,
  ) async {
    if (state is UsersLoaded) {
      final current = state as UsersLoaded;
      emit(current.copyWith(
        selectedUserId: event.userId,
        clearSelected: event.userId == null,
      ));
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await createUser(
      params: CreateUserParams(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }

  Future<void> _onInviteUsers(
    InviteUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    for (final email in event.emails) {
      await createUser(
        params: CreateUserParams(
          displayName: email.split('@').first,
          email: email,
          password: '',
        ),
      );
    }
    add(const LoadUsers());
  }

  void _onToggleUserSelection(
      ToggleUserSelection event, Emitter<UsersState> emit) {
    if (state is UsersLoaded) {
      final current = state as UsersLoaded;
      final updated = Set<String>.from(current.selectedUserIds);
      if (updated.contains(event.userId)) {
        updated.remove(event.userId);
      } else {
        updated.add(event.userId);
      }
      emit(current.copyWith(selectedUserIds: updated));
    }
  }

  void _onToggleSelectAll(
      ToggleSelectAll event, Emitter<UsersState> emit) {
    if (state is UsersLoaded) {
      final current = state as UsersLoaded;
      if (current.isAllSelected) {
        emit(current.copyWith(selectedUserIds: {}));
      } else {
        emit(current.copyWith(
          selectedUserIds: current.users.map((u) => u.id).toSet(),
        ));
      }
    }
  }

  void _onClearSelection(ClearSelection event, Emitter<UsersState> emit) {
    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(selectedUserIds: {}));
    }
  }

  Future<void> _onDeleteUsers(
    DeleteUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    for (final userId in event.userIds) {
      final result = await deleteUser(
          params: DeleteUserParams(userId: userId));
      result.fold(
        (failure) {
          emit(UsersError(failure.message));
          return;
        },
        (_) {},
      );
    }
    add(const LoadUsers());
  }

  Future<void> _onBanUsers(
    BanUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    for (final userId in event.userIds) {
      final result = await banUser(
          params: BanUserParams(userId: userId, isBanned: event.ban));
      result.fold(
        (failure) {
          emit(UsersError(failure.message));
          return;
        },
        (_) {},
      );
    }
    add(const LoadUsers());
  }

  Future<void> _onEditUser(
    EditUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await updateUser(
        params: UpdateUserParams(user: event.updatedUser));
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }

  Future<void> _onMergeUsers(
    MergeUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await mergeUsers(
      params: MergeUsersParams(
        primaryUserId: event.primaryUserId,
        secondaryUserId: event.secondaryUserId,
      ),
    );
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }

  Future<void> _onAddUsersToGroup(
    AddUsersToGroupEvent event,
    Emitter<UsersState> emit,
  ) async {
    final membersResult = await getGroupMembers(
      params: GetGroupMembersParams(groupId: event.groupId),
    );
    final userIdsToAdd = membersResult.fold(
      (failure) => event.userIds,
      (members) {
        final existingIds = members.map((m) => m.userId).toSet();
        return event.userIds
            .where((id) => !existingIds.contains(id))
            .toList();
      },
    );
    if (userIdsToAdd.isEmpty) return;

    final result = await addGroupMembers(
      params: AddGroupMembersParams(
        groupId: event.groupId,
        userIds: userIdsToAdd,
      ),
    );
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }

  Future<void> _onRemoveUsersFromGroup(
    RemoveUsersFromGroupEvent event,
    Emitter<UsersState> emit,
  ) async {
    final result = await removeGroupMembers(
      params: RemoveGroupMembersParams(
        groupId: event.groupId,
        userIds: event.userIds,
      ),
    );
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) => add(const LoadUsers()),
    );
  }
}
