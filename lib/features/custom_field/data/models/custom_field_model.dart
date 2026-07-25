import '../../domain/entities/custom_field.dart';
import '../../domain/entities/field_type.dart';

class CustomFieldModel extends CustomField {
  const CustomFieldModel({
    required super.id,
    required super.projectId,
    required super.name,
    super.description,
    required super.type,
    super.isPrivate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CustomFieldModel.fromEntity(CustomField entity) {
    return CustomFieldModel(
      id: entity.id,
      projectId: entity.projectId,
      name: entity.name,
      description: entity.description,
      type: entity.type,
      isPrivate: entity.isPrivate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory CustomFieldModel.fromJson(Map<String, dynamic> json) {
    return CustomFieldModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      type: FieldType.fromValue(json['type']?.toString() ?? ''),
      isPrivate: json['is_private'] as bool? ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  @override
  CustomFieldModel copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    FieldType? type,
    bool? isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomFieldModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'name': name,
      'description': description,
      'type': type.value,
      'is_private': isPrivate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'project_id': projectId,
      'name': name,
      'description': description,
      'type': type.value,
      'is_private': isPrivate,
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