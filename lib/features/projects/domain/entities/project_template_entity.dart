import '../../../../core/entities/entity.dart';

class ProjectTemplateEntity extends Entity {
  final String id;
  final String name;
  final String description;
  final String iconKey;
  final Map<String, String> defaultFields;

  const ProjectTemplateEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
    required this.defaultFields,
  });

  @override
  ProjectTemplateEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconKey,
    Map<String, String>? defaultFields,
  }) {
    return ProjectTemplateEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      defaultFields: defaultFields ?? this.defaultFields,
    );
  }

  @override
  List<Object?> get props => [id, name, description, iconKey, defaultFields];
}
