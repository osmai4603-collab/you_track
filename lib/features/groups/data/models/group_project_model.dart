import 'package:issues_tracking/core/models/project_data_model.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';

// osmskillsantigravity@gmail.com
final class GroupProjectModel extends GroupProjectEntity {
  const GroupProjectModel({
    required super.id,
    required super.groupId,
    required super.projectId,
    super.project,
  });

  factory GroupProjectModel.fromJson(Map<String, dynamic> data) {
    return GroupProjectModel(
      id: data['id'],
      groupId: data['group_id'],
      projectId: data['project_id'],
      project: data['projects'] == null
          ? null
          : ProjectDataModel.fromjson(data['projects']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'group_id': groupId, 'project_id': projectId};
  }
}
