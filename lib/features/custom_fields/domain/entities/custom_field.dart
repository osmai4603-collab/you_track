import 'field_type.dart';

class CustomField {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final FieldType type;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomField({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.type,
    this.isPrivate = false,
    required this.createdAt,
    required this.updatedAt,
  });

  CustomField copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    FieldType? type,
    bool? isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomField(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  List<Object?> get props => [
        id,
        projectId,
        name,
        description,
        type,
        isPrivate,
        createdAt,
        updatedAt,
      ];
}