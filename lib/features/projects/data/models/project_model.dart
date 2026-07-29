import 'package:issues_tracking/core/enums/project_template_enum.dart';

import '../../domain/entities/project_entity.dart';
import '../../data/models/project_member_model.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.projectId,
    super.description,
    super.isArchived,
    required super.templateType,
    required super.ownerId,
    required super.createdAt,
    super.isFavorite,
    super.members,
  });

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      projectId: entity.projectId,
      description: entity.description,
      isArchived: entity.isArchived,
      templateType: entity.templateType,
      ownerId: entity.ownerId,
      createdAt: entity.createdAt,
      isFavorite: entity.isFavorite,
      members: entity.members
          .map((m) => ProjectMemberModel.fromEntity(m))
          .toList(),
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // print('project: $json');
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      projectId: json['project_id'],
      description: json['description'],
      isArchived: json['is_archived'] == true,
      templateType: ProjectTemplateType.of(json['template_type']),
      ownerId: json['owner_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      isFavorite: json['is_favorite'] == true,
      members: (json['project_members'] ?? json['members'] as List? ?? [])
          .map<ProjectMemberModel>(
            (m) => ProjectMemberModel.fromJson(m as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'project_id': projectId,
      'description': description,
      'is_archived': isArchived,
      'template_type': templateType.name,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
      'members': members
          .map((m) => (m as ProjectMemberModel).toJson())
          .toList(),
    };
  }
}
