import 'package:issues_tracking/core/entities/user_role_assignment.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class UserRoleAssignmentModel extends UserRoleAssignment {
  const UserRoleAssignmentModel({
    required super.roleName,
    required super.permissions,
    required super.projectId,
    required super.groupId,
  });

  factory UserRoleAssignmentModel.fromJson(Map<String, dynamic> data) {
    printMap(title: 'UserRoleAssignmentModel.fromJson', data: data);
    return UserRoleAssignmentModel(
      roleName: data['role_name'] ?? '',
      permissions: (data['permissions'] as List<dynamic>?)
              ?.map((e) => Permission.of(e.toString()))
              .toList() ??
          [],
      projectId: data['project_id'],
      groupId: data['group_id'] ?? '',
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
