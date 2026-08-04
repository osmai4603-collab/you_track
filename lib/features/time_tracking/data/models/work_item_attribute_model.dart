import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_value_entity.dart';

import '../../domain/entities/work_item_attribute_entity.dart';
import 'attribute_value_model.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class WorkItemAttributeModel extends WorkItemAttributeEntity {
  const WorkItemAttributeModel({
    required super.id,
    required super.name,
    required super.projectId,
    required super.values,
  });

  factory WorkItemAttributeModel.fromEntity(WorkItemAttributeEntity entity) {
    return WorkItemAttributeModel(
      id: entity.id,
      name: entity.name,
      projectId: entity.projectId,
      values: entity.values
          .map((v) => AttributeValueModel.fromEntity(v))
          .toList(),
    );
  }

  factory WorkItemAttributeModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'WorkItemAttribute', data: json);
    return WorkItemAttributeModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      values: AttributeValueModel.fromJsonList(json['attribute_values']),
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id.isNotEmpty) 'id': id, 'project_id': projectId, 'name': name};
  }

  Map<String, dynamic> toInsertJson() {
    return {'project_id': projectId, 'name': name};
  }

  @override
  WorkItemAttributeModel copyWith({
    String? id,
    String? name,
    String? projectKey,
    List<WorkItemAttributeValueEntity>? values,
  }) {
    return WorkItemAttributeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectKey ?? this.projectId,
      values: values ?? this.values,
    );
  }
}
