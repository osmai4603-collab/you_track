import 'package:equatable/equatable.dart';

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
