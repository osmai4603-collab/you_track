import 'package:equatable/equatable.dart';

/// A single role held by a user, together with the permission names it grants
/// within its own scope. An empty [projectId] means a global role.
class UserRoleAssignmentModel extends Equatable {
  final String roleId;
  final String roleName;
  final String projectId;
  final String groupId;
  final List<String> permissions;

  const UserRoleAssignmentModel({
    required this.roleId,
    required this.roleName,
    required this.projectId,
    required this.groupId,
    required this.permissions,
  });

  factory UserRoleAssignmentModel.fromJson(Map<String, dynamic> data) {
    final rawPermissions = data['permissions'];
    return UserRoleAssignmentModel(
      roleId: (data['roleId'] ?? data['role_id'] ?? '').toString(),
      roleName: (data['roleName'] ?? data['role_name'] ?? '').toString(),
      projectId: (data['projectId'] ?? data['project_id'] ?? '').toString(),
      groupId: (data['groupId'] ?? data['group_id'] ?? '').toString(),
      permissions: rawPermissions is List
          ? rawPermissions.map((e) => e.toString()).toList(growable: false)
          : const [],
    );
  }

  @override
  List<Object?> get props => [
    roleId,
    roleName,
    projectId,
    groupId,
    permissions,
  ];
}

/// The full permission picture for a user: every role they hold plus the
/// projects they own outright.
class UserPermissionsModel extends Equatable {
  final List<UserRoleAssignmentModel> roleAssignments;
  final List<String> ownedProjectIds;

  const UserPermissionsModel({
    required this.roleAssignments,
    required this.ownedProjectIds,
  });

  factory UserPermissionsModel.fromJson(Map<String, dynamic> data) {
    // printMap(title: 'user permissions', data: data);
    final rawAssignments =
        data['roleAssignments'] ?? data['role_assignments'] ?? const [];
    final rawOwned =
        data['ownedProjectIds'] ?? data['owned_project_ids'] ?? const [];

    return UserPermissionsModel(
      roleAssignments: rawAssignments is List
          ? rawAssignments
                .whereType<Map>()
                .map(
                  (e) => UserRoleAssignmentModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList(growable: false)
          : const [],
      ownedProjectIds: rawOwned is List
          ? rawOwned.map((e) => e.toString()).toList(growable: false)
          : const [],
    );
  }

  @override
  List<Object?> get props => [roleAssignments, ownedProjectIds];
}
