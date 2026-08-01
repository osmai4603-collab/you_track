import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';

class UserRoleAssignment extends Entity {
  final String roleName;
  final List<Permission> permissions;
  final String? projectId; // null means global permission
  final String groupId;

  const UserRoleAssignment({
    required this.roleName,
    required this.permissions,
    this.projectId,
    required this.groupId,
  });

  @override
  UserRoleAssignment copyWith({
    String? roleName,
    List<Permission>? permissions,
    String? projectId,
    String? groupId,
  }) {
    return UserRoleAssignment(
      roleName: roleName ?? this.roleName,
      permissions: permissions ?? this.permissions,
      projectId: projectId ?? this.projectId,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  List<Object?> get props => [roleName, permissions, projectId, groupId];
}
