import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/entities/project_data.dart';

class GroupProjectEntity extends Entity {
  final String id;
  final String projectId;
  final String groupId;
  final ProjectData? project;

  const GroupProjectEntity({
    required this.id,
    required this.groupId,
    required this.projectId,
    this.project,
  });

  @override
  GroupProjectEntity copyWith({
    String? id,
    String? projectKey,
    String? groupId,
    ProjectData? project,
  }) {
    return GroupProjectEntity(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      projectId: projectKey ?? this.projectId,
      project: project ?? this.project,
    );
  }

  @override
  List<Object?> get props => [id, groupId, projectId, project];
}
