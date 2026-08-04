import 'package:issues_tracking/core/entities/entity.dart';

class ProjectData extends Entity {
  final String id;
  final String projectName;
  final String projectId;

  const ProjectData({
    required this.id,
    required this.projectName,
    required this.projectId,
  });

  @override
  Entity copyWith({String? id, String? projectName, String? projectKey}) {
    return ProjectData(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      projectId: projectKey ?? this.projectId,
    );
  }

  @override
  List<Object?> get props => [id, projectName, projectId];
}
