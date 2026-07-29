import 'dart:convert';
import '../../domain/entities/project_template_entity.dart';

class ProjectTemplateModel extends ProjectTemplateEntity {
  const ProjectTemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconKey,
    required super.defaultFields,
  });

  factory ProjectTemplateModel.fromEntity(ProjectTemplateEntity entity) {
    return ProjectTemplateModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconKey: entity.iconKey,
      defaultFields: entity.defaultFields,
    );
  }

  factory ProjectTemplateModel.fromJson(Map<String, dynamic> json) {
    final fieldsRaw = json['default_fields'] ?? json['defaultFields'];
    Map<String, String> parsedFields = {};
    if (fieldsRaw is String) {
      try {
        final decoded = jsonDecode(fieldsRaw) as Map<String, dynamic>;
        parsedFields = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {
        parsedFields = {};
      }
    } else if (fieldsRaw is Map) {
      parsedFields = fieldsRaw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    return ProjectTemplateModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      iconKey: (json['icon_key'] ?? json['iconKey'] ?? '').toString(),
      defaultFields: parsedFields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'description': description,
      'icon_key': iconKey,
      'default_fields': defaultFields,
    };
  }
}
