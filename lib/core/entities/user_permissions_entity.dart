import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/entities/user_role_assignment.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';

class UserPermissionsEntity extends Entity {
  final List<UserRoleAssignment> roleAssignments;
  final List<String> ownedProjectIds;

  const UserPermissionsEntity({
    required this.roleAssignments,
    required this.ownedProjectIds,
  });

  bool hasGlobalPermission(Permission permission) {
    return roleAssignments
        .any((role) => role.permissions.contains(permission));
  }


  bool hasGlobalAnyPermission(List<Permission> permissions) {
    return roleAssignments
        .any((role) => role.permissions.any((p) => permissions.contains(p)));
  }

  bool hasProjectPermission(String projectId, Permission permission) {
    if (isProjectOwner(projectId)) return true;
    
    return roleAssignments
        .where((role) => role.projectId == projectId)
        .any((role) => role.permissions.contains(permission));
  }

  bool isProjectOwner(String projectId) {
    return ownedProjectIds.contains(projectId);
  }

  Set<Permission> getProjectPermissions(String projectId) {
    if (isProjectOwner(projectId)) {
      return Permission.values.toSet();
    }
    
    final permissions = <Permission>{};
    for (final role in roleAssignments) {
      if (role.projectId == projectId) {
        permissions.addAll(role.permissions);
      }
    }
    return permissions;
  }
  
  List<String> getProjectsWithPermission(Permission permission) {
    final projectIds = <String>{...ownedProjectIds};
    
    for (final role in roleAssignments) {
      if (role.permissions.contains(permission)) {
        projectIds.add(role.projectId);
      }
    }
    return projectIds.toList();
  }

  @override
  UserPermissionsEntity copyWith({
    List<UserRoleAssignment>? roleAssignments,
    List<String>? ownedProjectIds,
  }) {
    return UserPermissionsEntity(
      roleAssignments: roleAssignments ?? this.roleAssignments,
      ownedProjectIds: ownedProjectIds ?? this.ownedProjectIds,
    );
  }

  @override
  List<Object?> get props => [roleAssignments, ownedProjectIds];
}
