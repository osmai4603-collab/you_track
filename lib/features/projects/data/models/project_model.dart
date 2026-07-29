import '../../domain/entities/project_entity.dart';
import '../../data/models/project_member_model.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.projectKey,
    super.description,
    super.isArchived,
    super.isTemplate,
    super.templateId,
    required super.ownerId,
    required super.createdAt,
    super.isFavorite,
    super.members,
  });

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      projectKey: entity.projectKey,
      description: entity.description,
      isArchived: entity.isArchived,
      isTemplate: entity.isTemplate,
      templateId: entity.templateId,
      ownerId: entity.ownerId,
      createdAt: entity.createdAt,
      isFavorite: entity.isFavorite,
      members: entity.members
          .map((m) => ProjectMemberModel.fromEntity(m))
          .toList(),
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      projectKey: (json['key'] ?? json['projectKey'] ?? '').toString(),
      description: json['description']?.toString(),
      isArchived:
          json['is_archived'] == true || (json['is_archived'] ?? 0) == 1,
      isTemplate:
          json['is_template'] == true || (json['is_template'] ?? 0) == 1,
      templateId: json['template_id']?.toString(),
      ownerId: (json['owner_id'] ?? json['owner'] ?? '').toString(),
      createdAt: _parseDate(json['created_at']),
      isFavorite:
          json['is_favorite'] == true || (json['is_favorite'] ?? 0) == 1,
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
      'key': projectKey,
      'description': description,
      'is_archived': isArchived,
      'is_template': isTemplate,
      'template_id': templateId,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
      'members': members
          .map((m) => (m as ProjectMemberModel).toJson())
          .toList(),
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
