import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class DashboardModel extends Dashboard {
  const DashboardModel({
    required super.id,
    required super.name,
    required super.ownerId,
    super.isDefault,
    super.isFavorite,
    super.layoutConfig,
    required super.createdAt,
    required super.updatedAt,
    super.widgets,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Dashboard', data: json);
    return DashboardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['owner_id'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
      layoutConfig: json['layout_config'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'owner_id': ownerId,
      'is_default': isDefault,
      'is_favorite': isFavorite,
      'layout_config': layoutConfig,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
