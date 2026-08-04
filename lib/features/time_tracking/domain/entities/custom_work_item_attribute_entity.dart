import '../../../../core/entities/entity.dart';
import '../../../../core/enums/time_tracking_field_type_enum.dart';

class CustomWorkItemAttributeEntity extends Entity {
  final String id;
  final String projectId;
  final String name;
  final TimeTrackingFieldType fieldType;
  final bool isRequired;
  final List<String>? options;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomWorkItemAttributeEntity({
    required this.id,
    required this.projectId,
    required this.name,
    required this.fieldType,
    this.isRequired = false,
    this.options,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  CustomWorkItemAttributeEntity copyWith({
    String? id,
    String? projectKey,
    String? name,
    TimeTrackingFieldType? fieldType,
    bool? isRequired,
    List<String>? options,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomWorkItemAttributeEntity(
      id: id ?? this.id,
      projectId: projectKey ?? this.projectId,
      name: name ?? this.name,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    name,
    fieldType,
    isRequired,
    options,
    sortOrder,
    createdAt,
    updatedAt,
  ];
}
