import 'package:issues_tracking/core/entities/user_role_assignment.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';

class UserRoleAssignmentModel extends UserRoleAssignment {
  const UserRoleAssignmentModel({
    required super.roleName,
    required super.permissions,
    super.projectId,
    required super.groupId,
  });

  factory UserRoleAssignmentModel.fromJson(Map<String, dynamic> json) {
    return UserRoleAssignmentModel(
      roleName: json['role_name'] ?? '',
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => Permission.of(e.toString()))
              .toList() ??
          [],
      projectId: json['project_id'],
      groupId: json['group_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_name': roleName,
      'permissions': permissions.map((e) => e.name).toList(),
      'project_id': projectId,
      'group_id': groupId,
    };
  }
}
