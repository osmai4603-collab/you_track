import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';

abstract class RolesState extends Equatable {
  const RolesState();

  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  final List<RoleEntity> roles;
  final String? selectedRoleId;

  const RolesLoaded({
    required this.roles,
    this.selectedRoleId,
  });

  RolesLoaded copyWith({
    List<RoleEntity>? roles,
    String? selectedRoleId,
    bool clearSelected = false,
  }) {
    return RolesLoaded(
      roles: roles ?? this.roles,
      selectedRoleId:
          clearSelected ? null : (selectedRoleId ?? this.selectedRoleId),
    );
  }

  @override
  List<Object?> get props => [roles, selectedRoleId];
}

class RolesError extends RolesState {
  final String message;

  const RolesError(this.message);

  @override
  List<Object?> get props => [message];
}
