import 'package:issues_tracking/core/entities/entity.dart';

class WorkItemAttributeValueEntity extends Entity {
  final String id;
  final String value;
  final int color;
  final String attributeId;
  final String firstLetter;

  const WorkItemAttributeValueEntity({
    required this.id,
    required this.value,
    required this.color,
    required this.attributeId,
    required this.firstLetter,
  });
  
  @override
  WorkItemAttributeValueEntity copyWith({
    String? id,
    String? value,
    int? color,
    String? firstLetter,
    String? attributeId,
  }) {
    return WorkItemAttributeValueEntity(
      id: id ?? this.id,
      value: value ?? this.value,
      color: color ?? this.color,
      firstLetter: firstLetter ?? this.firstLetter,
      attributeId: attributeId ?? this.attributeId,
    );
  }
  
  @override
  List<Object?> get props => [id, value, color, firstLetter, attributeId];
}
