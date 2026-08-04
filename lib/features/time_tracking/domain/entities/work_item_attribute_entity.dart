import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_value_entity.dart';

class WorkItemAttributeEntity extends Entity {
  final String id;
  final String name;
  final String projectId;
  final List<WorkItemAttributeValueEntity> values;

  const WorkItemAttributeEntity({
    required this.id,
    required this.name,
    required this.projectId,
    required this.values,
  });

  @override
  WorkItemAttributeEntity copyWith({
    String? id,
    String? name,
    String? projectKey,
    List<WorkItemAttributeValueEntity>? values,
  }) {
    return WorkItemAttributeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectKey ?? this.projectId,
      values: values ?? this.values,
    );
  }

  @override
  List<Object?> get props => [id, name, projectId, values];
}
