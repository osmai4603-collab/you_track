import 'dart:convert';
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
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      projectKey: (map['projectKey'] ?? map['project_key'] ?? '').toString(),
      description: map['description']?.toString(),
      isArchived: (map['isArchived'] ?? map['is_archived'] ?? 0) == 1 ||
          (map['isArchived'] ?? map['is_archived']) == true,
      isTemplate: (map['isTemplate'] ?? map['is_template'] ?? 0) == 1 ||
          (map['isTemplate'] ?? map['is_template']) == true,
      templateId:
          map['templateId']?.toString() ?? map['template_id']?.toString(),
      owner: (map['owner'] ?? '').toString(),
      createdAt: _parseDate(map['createdAt'] ?? map['created_at']),
      isFavorite: (map['isFavorite'] ?? map['is_favorite'] ?? 0) == 1 ||
          (map['isFavorite'] ?? map['is_favorite']) == true,
      memberInitials:
          _parseList(map['memberInitials'] ?? map['member_initials']),
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

  factory ProjectModel.fromJson(Map<String, dynamic> json) {

    return ProjectModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      projectKey: (json['project_key'] ?? json['projectKey'] ?? '').toString(),
      description: json['description']?.toString(),
      isArchived: json['is_archived'] == true || (json['is_archived'] ?? 0) == 1,
      isTemplate: json['is_template'] == true || (json['is_template'] ?? 0) == 1,
      templateId:
          json['template_id']?.toString() ?? json['templateId']?.toString(),
      owner: (json['owner'] ?? '').toString(),
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      isFavorite: json['is_favorite'] == true || (json['is_favorite'] ?? 0) == 1,
      memberInitials:
          _parseList(json['member_initials'] ?? json['memberInitials']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'project_key': projectKey,
      'description': description,
      'is_archived': isArchived,
      'is_template': isTemplate,
      'template_id': templateId,
      'owner': owner,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
      'member_initials': memberInitials,
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

  static List<String> _parseList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }
    return const [];
  }
}
