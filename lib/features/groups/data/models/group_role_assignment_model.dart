import 'package:issues_tracking/core/models/project_data_model.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class GroupRoleAssignmentModel extends GroupRoleAssignmentEntity {
  const GroupRoleAssignmentModel({
    required super.id,
    required super.groupId,
    required super.roleName,
    super.projectId,
    super.project,
  });

  factory GroupRoleAssignmentModel.fromEntity(
    GroupRoleAssignmentEntity entity,
  ) {
    return GroupRoleAssignmentModel(
      id: entity.id,
      groupId: entity.groupId,
      roleName: entity.roleName,
      projectId: entity.projectId,
      project: entity.project,
    );
  }

  factory GroupRoleAssignmentModel.fromJson(Map<String, dynamic> data) {
    printMap(title: 'GroupRoleAssignment', data: data);
    return GroupRoleAssignmentModel(
      id: (data['id'] ?? '').toString(),
      groupId: (data['group_id'] ?? '').toString(),
      roleName: (data['role_name'] ?? '').toString(),
      projectId: data['project_id']?.toString(),
      project: data['projects'] == null
          ? null
          : ProjectDataModel.fromjson(data['projects']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'role_name': roleName,
      'project_id': projectId,
    };
  }
}
