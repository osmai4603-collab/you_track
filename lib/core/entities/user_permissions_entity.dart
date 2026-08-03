import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/entities/user_role_assignment.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';

class UserPermissionsEntity extends Entity {
  final List<UserRoleAssignment> roleAssignments;
  final List<String> ownedProjectIds;

  // Cache for effective permissions
  late final Set<Permission> _globalEffectivePermissions;
  late final Map<String, Set<Permission>> _projectEffectivePermissions;

  UserPermissionsEntity({
    required this.roleAssignments,
    required this.ownedProjectIds,
  }) {
    _projectEffectivePermissions = {};
    final allDirectPermissions = roleAssignments.expand((r) => r.permissions).toSet();
    _globalEffectivePermissions = Permission.resolveEffective(allDirectPermissions);

    for (final role in roleAssignments) {
      final effective = Permission.resolveEffective(role.permissions);
      _projectEffectivePermissions
          .putIfAbsent(role.projectId, () => <Permission>{})
          .addAll(effective);
    }

    
  }

  bool hasGlobalPermission(Permission permission) {
    return _globalEffectivePermissions.contains(permission) &&
        permission.arePrerequisitesMet(_globalEffectivePermissions);
  }

  bool hasGlobalAnyPermission(List<Permission> permissions) {
    return permissions.any((p) => hasGlobalPermission(p));
  }

  bool hasProjectPermission(String projectId, Permission permission) {
    if (isProjectOwner(projectId)) return true;

    final projectPermissions = _projectEffectivePermissions[projectId] ?? {};
    return projectPermissions.contains(permission) &&
        permission.arePrerequisitesMet(projectPermissions);
  }

  bool isProjectOwner(String projectId) {
    return ownedProjectIds.contains(projectId);
  }

  Set<Permission> getProjectPermissions(String projectId) {
    if (isProjectOwner(projectId)) {
      return Permission.values.toSet();
    }

    final permissions = _projectEffectivePermissions[projectId] ?? {};
    // Filter by prerequisites for consistency
    return permissions
        .where((p) => p.arePrerequisitesMet(permissions))
        .toSet();
  }

  List<String> getProjectsWithPermission(Permission permission) {
    final projectIds = <String>{...ownedProjectIds};

    _projectEffectivePermissions.forEach((projectId, permissions) {
      if (permissions.contains(permission) &&
          permission.arePrerequisitesMet(permissions)) {
        projectIds.add(projectId);
      }
    });
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
