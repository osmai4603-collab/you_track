import '../../domain/entities/custom_field_value_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class CustomFieldValueModel extends CustomFieldValueEntity {
  const CustomFieldValueModel({
    required super.id,
    required super.issueId,
    required super.customFieldId,
    required super.value,
  });

  factory CustomFieldValueModel.fromEntity(CustomFieldValueEntity entity) {
    return CustomFieldValueModel(
      id: entity.id,
      issueId: entity.issueId,
      customFieldId: entity.customFieldId,
      value: entity.value,
    );
  }

  factory CustomFieldValueModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'CustomFieldValue', data: json);
    return CustomFieldValueModel(
      id: (json['id'] ?? '').toString(),
      issueId: (json['issue_id'] ?? '').toString(),
      customFieldId: (json['custom_field_id'] ?? '').toString(),
      value: (json['value'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'issue_id': issueId,
      'custom_field_id': customFieldId,
      'value': value,
    };
  }
}
