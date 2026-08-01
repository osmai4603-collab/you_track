import '../../domain/entities/work_item_attribute_value_entity.dart';

class AttributeValueModel extends WorkItemAttributeValueEntity {
  const AttributeValueModel({
    required super.attributeId,
    required super.id,
    required super.value,
    required super.color,
    required super.firstLetter,
  });

  factory AttributeValueModel.fromEntity(WorkItemAttributeValueEntity entity) {
    return AttributeValueModel(
      attributeId: entity.attributeId,
      id: entity.id,
      value: entity.value,
      color: entity.color,
      firstLetter: entity.firstLetter,
    );
  }

  factory AttributeValueModel.fromJson(Map<String, dynamic> json) {
    return AttributeValueModel(
      id: json['id'],
      value: json['value'],
      color: json['color'],
      attributeId: json['attribute_id'],
      firstLetter: (json['first_letter'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'value': value,
      'color': color,
      'first_letter': firstLetter,
      'attribute_id': attributeId,
    };
  }

  static List<AttributeValueModel> fromJsonList(List<dynamic>? json) {
    if (json is List) {
      return json.map((e) => AttributeValueModel.fromJson(e)).toList();
    }
    return [];
  }
}
