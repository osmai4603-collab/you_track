import '../../domain/entities/custom_field_entity.dart';
import '../../../../core/enums/custom_field_type_enum.dart';

class CustomFieldModel extends CustomFieldEntity {
  const CustomFieldModel({
    required super.id,
    required super.projectId,
    required super.name,
    required super.fieldType,
    super.fieldMode,
    super.valueMode,
    super.defaultValue,
    super.emptyValue,
    super.canBeEmpty,
    super.aliases,
    super.visibleTo,
    super.updatableBy,
    super.showOnlyWhen,
    super.filterValuesBasedOn,
    super.orderIndex,
    super.visibility,
    super.accessControl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CustomFieldModel.fromEntity(CustomFieldEntity entity) {
    return CustomFieldModel(
      id: entity.id,
      projectId: entity.projectId,
      name: entity.name,
      fieldType: entity.fieldType,
      fieldMode: entity.fieldMode,
      valueMode: entity.valueMode,
      defaultValue: entity.defaultValue,
      emptyValue: entity.emptyValue,
      canBeEmpty: entity.canBeEmpty,
      aliases: entity.aliases,
      visibleTo: entity.visibleTo,
      updatableBy: entity.updatableBy,
      showOnlyWhen: entity.showOnlyWhen,
      filterValuesBasedOn: entity.filterValuesBasedOn,
      orderIndex: entity.orderIndex,
      visibility: entity.visibility,
      accessControl: entity.accessControl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory CustomFieldModel.fromJson(Map<String, dynamic> json) {
    return CustomFieldModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      fieldType: CustomFieldEnumType.fromValue(json['field_type']?.toString() ?? ''),
      fieldMode: (json['field_mode'] ?? 'ownedField').toString(),
      valueMode: (json['value_mode'] ?? 'single').toString(),
      defaultValue: json['default_value']?.toString(),
      emptyValue: json['empty_value']?.toString(),
      canBeEmpty: json['can_be_empty'] as bool? ?? true,
      aliases: _parseStringList(json['aliases']),
      visibleTo: _parseStringList(json['visible_to']),
      updatableBy: _parseStringList(json['updatable_by']),
      showOnlyWhen: json['show_only_when']?.toString(),
      filterValuesBasedOn: json['filter_values_based_on']?.toString(),
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      visibility: (json['visibility'] ?? 'show').toString(),
      accessControl: _parseAccessControl(json['access_control']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'name': name,
      'field_type': fieldType.value,
      'field_mode': fieldMode,
      'value_mode': valueMode,
      'default_value': defaultValue,
      'empty_value': emptyValue,
      'can_be_empty': canBeEmpty,
      'aliases': aliases,
      'visible_to': visibleTo,
      'updatable_by': updatableBy,
      'show_only_when': showOnlyWhen,
      'filter_values_based_on': filterValuesBasedOn,
      'order_index': orderIndex,
      'visibility': visibility,
      'access_control': accessControl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'project_id': projectId,
      'name': name,
      'field_type': fieldType.value,
      'field_mode': fieldMode,
      'value_mode': valueMode,
      'default_value': defaultValue,
      'empty_value': emptyValue,
      'can_be_empty': canBeEmpty,
      'aliases': aliases,
      'visible_to': visibleTo,
      'updatable_by': updatableBy,
      'show_only_when': showOnlyWhen,
      'filter_values_based_on': filterValuesBasedOn,
      'order_index': orderIndex,
      'visibility': visibility,
      'access_control': accessControl,
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

  static Map<String, dynamic> _parseAccessControl(dynamic value) {
    if (value == null) return {'type': 'everyone'};
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {'type': 'everyone'};
  }
}
