import '../../../../core/enums/time_tracking_field_type_enum.dart';
import '../../domain/entities/custom_work_item_attribute_entity.dart';

class CustomWorkItemAttributeModel extends CustomWorkItemAttributeEntity {
  const CustomWorkItemAttributeModel({
    required super.id,
    required super.projectId,
    required super.name,
    required super.fieldType,
    super.isRequired,
    super.options,
    super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CustomWorkItemAttributeModel.fromEntity(CustomWorkItemAttributeEntity entity) {
    return CustomWorkItemAttributeModel(
      id: entity.id,
      projectId: entity.projectId,
      name: entity.name,
      fieldType: entity.fieldType,
      isRequired: entity.isRequired,
      options: entity.options,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory CustomWorkItemAttributeModel.fromJson(Map<String, dynamic> json) {
    return CustomWorkItemAttributeModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      fieldType: TimeTrackingFieldType.fromValue(json['field_type']?.toString() ?? 'text'),
      isRequired: json['is_required'] as bool? ?? false,
      options: _parseStringList(json['options']),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'name': name,
      'field_type': fieldType.value,
      'is_required': isRequired,
      'options': options,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'project_id': projectId,
      'name': name,
      'field_type': fieldType.value,
      'is_required': isRequired,
      'options': options,
      'sort_order': sortOrder,
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

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}
