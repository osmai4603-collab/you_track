import '../../../../core/entities/entity.dart';

class CustomFieldValueEntity extends Entity {
  final String id;
  final String issueId;
  final String customFieldId;
  final String value;

  const CustomFieldValueEntity({
    required this.id,
    required this.issueId,
    required this.customFieldId,
    required this.value,
  });

  @override
  CustomFieldValueEntity copyWith({
    String? id,
    String? issueId,
    String? customFieldId,
    String? value,
  }) {
    return CustomFieldValueEntity(
      id: id ?? this.id,
      issueId: issueId ?? this.issueId,
      customFieldId: customFieldId ?? this.customFieldId,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [id, issueId, customFieldId, value];
}
