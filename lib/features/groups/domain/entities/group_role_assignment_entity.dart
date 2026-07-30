import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/entities/project_data.dart';

class GroupRoleAssignmentEntity extends Entity {
  final String id;
  final String groupId;
  final String roleName;
  final String? projectId;
  final ProjectData? project;

  const GroupRoleAssignmentEntity({
    required this.id,
    required this.groupId,
    required this.roleName,
    this.projectId,
    this.project,
  });

  @override
  GroupRoleAssignmentEntity copyWith({
    String? id,
    String? groupId,
    String? roleName,
    String? projectId,
    ProjectData? project,
  }) {
    return GroupRoleAssignmentEntity(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      roleName: roleName ?? this.roleName,
      projectId: projectId ?? this.projectId,
      project: project ?? this.project,
    );
  }

  @override
  List<Object?> get props => [id, groupId, roleName, projectId, project];
}
