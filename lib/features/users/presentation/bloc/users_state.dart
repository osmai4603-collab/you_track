import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final String? selectedUserId;
  final Set<String> selectedUserIds;

  const UsersLoaded({
    required this.users,
    this.selectedUserId,
    this.selectedUserIds = const {},
  });

  bool get isAllSelected =>
      users.isNotEmpty && selectedUserIds.length == users.length;

  bool get hasSelection => selectedUserIds.isNotEmpty;

  UsersLoaded copyWith({
    List<UserEntity>? users,
    String? selectedUserId,
    bool clearSelected = false,
    Set<String>? selectedUserIds,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      selectedUserId:
          clearSelected ? null : (selectedUserId ?? this.selectedUserId),
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
    );
  }

  @override
  List<Object?> get props => [users, selectedUserId, selectedUserIds];
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}
