import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.projectKey,
    super.description,
    super.isArchived,
    super.isTemplate,
    super.templateId,
    required super.owner,
    required super.createdAt,
    super.isFavorite,
    super.memberInitials,
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
      owner: entity.owner,
      createdAt: entity.createdAt,
      isFavorite: entity.isFavorite,
      memberInitials: entity.memberInitials,
    );
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      projectKey: map['projectKey'] as String,
      description: map['description'] as String?,
      isArchived: (map['isArchived'] as int? ?? 0) == 1,
      isTemplate: (map['isTemplate'] as int? ?? 0) == 1,
      templateId: map['templateId'] as String?,
      owner: map['owner'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isFavorite: (map['isFavorite'] as int? ?? 0) == 1,
      memberInitials: (map['memberInitials'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'projectKey': projectKey,
      'description': description,
      'isArchived': isArchived ? 1 : 0,
      'isTemplate': isTemplate ? 1 : 0,
      'templateId': templateId,
      'owner': owner,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
      'memberInitials': memberInitials,
    };
  }
}
