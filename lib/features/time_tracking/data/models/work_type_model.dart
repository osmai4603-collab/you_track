import '../../domain/entities/work_type_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class WorkTypeModel extends WorkTypeEntity {
  const WorkTypeModel({
    required super.id,
    required super.projectId,
    required super.name,
    super.description,
    super.isActive,
    super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WorkTypeModel.fromEntity(WorkTypeEntity entity) {
    return WorkTypeModel(
      id: entity.id,
      projectId: entity.projectId,
      name: entity.name,
      description: entity.description,
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory WorkTypeModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'WorkType', data: json);
    return WorkTypeModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'name': name,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'project_id': projectId,
      'name': name,
      'description': description,
      'is_active': isActive,
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
}
