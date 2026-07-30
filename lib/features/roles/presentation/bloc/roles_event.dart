import 'package:equatable/equatable.dart';

abstract class RolesEvent extends Equatable {
  const RolesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRoles extends RolesEvent {
  const LoadRoles();
}

class CreateRoleEvent extends RolesEvent {
  final String name;
  final String? description;
  final List<String> permissions;

  const CreateRoleEvent({required this.name, this.description, required this.permissions});

  @override
  List<Object?> get props => [name, description, permissions];
}

class UpdateRoleEvent extends RolesEvent {
  final String name;
  final String? description;
  final List<String> permissions;

  const UpdateRoleEvent({
    required this.name,
    this.description,
    required this.permissions,
  });

  @override
  List<Object?> get props => [name, description, permissions];
}

class DeleteRoleEvent extends RolesEvent {
  final String id;

  const DeleteRoleEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SelectRole extends RolesEvent {
  final String? roleId;

  const SelectRole(this.roleId);

  @override
  List<Object?> get props => [roleId];
}
