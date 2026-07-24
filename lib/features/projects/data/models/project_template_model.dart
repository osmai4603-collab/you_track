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

  factory ProjectTemplateModel.fromMap(Map<String, dynamic> map) {
    final fieldsRaw = map['defaultFields'];
    Map<String, String> parsedFields = {};
    if (fieldsRaw is String) {
      final decoded = jsonDecode(fieldsRaw) as Map<String, dynamic>;
      parsedFields = decoded.map((k, v) => MapEntry(k, v.toString()));
    } else if (fieldsRaw is Map) {
      parsedFields = fieldsRaw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    return ProjectTemplateModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconKey: map['iconKey'] as String,
      defaultFields: parsedFields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconKey': iconKey,
      'defaultFields': jsonEncode(defaultFields),
    };
  }
}
