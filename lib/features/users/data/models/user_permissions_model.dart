import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';
import 'package:issues_tracking/features/users/data/models/user_role_assignment_model.dart';

class UserPermissionsModel extends UserPermissionsEntity {
  const UserPermissionsModel({
    required super.roleAssignments,
    required super.ownedProjectIds,
  });

  factory UserPermissionsModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'UserPermissionsModel.fromJson', data: json);
    return UserPermissionsModel(
      roleAssignments: (json['role_assignments'] as List<dynamic>?)
              ?.map((e) => UserRoleAssignmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      ownedProjectIds: (json['owned_project_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_assignments':
          roleAssignments.map((e) => (e as UserRoleAssignmentModel).toJson()).toList(),
      'owned_project_ids': ownedProjectIds,
    };
  }
}
