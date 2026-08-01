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
        .where((role) => role.projectId == null)
        .any((role) => role.permissions.contains(permission));
  }

  bool hasProjectPermission(String projectId, Permission permission) {
    if (isProjectOwner(projectId)) return true;
    
    return roleAssignments
        .where((role) => role.projectId == projectId || role.projectId == null)
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
      if (role.projectId == projectId || role.projectId == null) {
        permissions.addAll(role.permissions);
      }
    }
    return permissions;
  }
  
  List<String> getProjectsWithPermission(Permission permission) {
    final projectIds = <String>{...ownedProjectIds};
    
    for (final role in roleAssignments) {
      if (role.permissions.contains(permission)) {
        if (role.projectId == null) {
          // If they have it globally, we don't know the exhaustive list of projects here,
          // but we can at least return all projects they are explicitly assigned to with this permission.
          // Wait, if it's global, they have it on all projects. This is tricky.
          // For now, let's just return the projects they are explicitly assigned to.
          // If needed, the caller should check `hasGlobalPermission` first.
        } else {
          projectIds.add(role.projectId!);
        }
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
