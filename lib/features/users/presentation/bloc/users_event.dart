import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {
  const LoadUsers();
}

class SelectUser extends UsersEvent {
  final String? userId;
  const SelectUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateUserEvent extends UsersEvent {
  final String displayName;
  final String email;
  final String password;

  const CreateUserEvent({
    required this.displayName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [displayName, email, password];
}

class InviteUsersEvent extends UsersEvent {
  final List<String> emails;

  const InviteUsersEvent({required this.emails});

  @override
  List<Object?> get props => [emails];
}

class ToggleUserSelection extends UsersEvent {
  final String userId;
  const ToggleUserSelection(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleSelectAll extends UsersEvent {
  const ToggleSelectAll();
}

class ClearSelection extends UsersEvent {
  const ClearSelection();
}

class DeleteUsersEvent extends UsersEvent {
  final List<String> userIds;
  const DeleteUsersEvent(this.userIds);

  @override
  List<Object?> get props => [userIds];
}

class BanUsersEvent extends UsersEvent {
  final List<String> userIds;
  final bool ban;
  const BanUsersEvent({required this.userIds, required this.ban});

  @override
  List<Object?> get props => [userIds, ban];
}

class EditUserEvent extends UsersEvent {
  final UserEntity updatedUser;
  const EditUserEvent(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

class MergeUsersEvent extends UsersEvent {
  final String primaryUserId;
  final String secondaryUserId;
  const MergeUsersEvent({required this.primaryUserId, required this.secondaryUserId});

  @override
  List<Object?> get props => [primaryUserId, secondaryUserId];
}

class AddUsersToGroupEvent extends UsersEvent {
  final List<String> userIds;
  final String groupId;
  const AddUsersToGroupEvent({required this.userIds, required this.groupId});

  @override
  List<Object?> get props => [userIds, groupId];
}

class RemoveUsersFromGroupEvent extends UsersEvent {
  final List<String> userIds;
  final String groupId;
  const RemoveUsersFromGroupEvent({required this.userIds, required this.groupId});

  @override
  List<Object?> get props => [userIds, groupId];
}
