import 'package:issues_tracking/core/entities/project_data.dart';
import 'package:issues_tracking/core/utils/printing.dart';

final class ProjectDataModel extends ProjectData {
  const ProjectDataModel({
    required super.id,
    required super.projectName,
    required super.projectId,
  });

  factory ProjectDataModel.fromjson(Map<String, dynamic> data) {
    printMap(title: 'Project: ', data: data);
    return ProjectDataModel(
      id: data['id'],
      projectName: data['name'],
      projectId: data['key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': projectName, 'project_id': projectId};
  }
}
