import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';

class DashboardWidgetModel extends DashboardWidget {
  const DashboardWidgetModel({
    required super.id,
    required super.dashboardId,
    required super.widgetType,
    required super.title,
    super.config,
    super.positionX,
    super.positionY,
    super.width,
    super.height,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DashboardWidgetModel.fromJson(Map<String, dynamic> json) {
    return DashboardWidgetModel(
      id: json['id'] as String,
      dashboardId: json['dashboard_id'] as String,
      widgetType: json['widget_type'] as String,
      title: json['title'] as String,
      config: json['config'] as Map<String, dynamic>? ?? {},
      positionX: json['position_x'] as int? ?? 0,
      positionY: json['position_y'] as int? ?? 0,
      width: json['width'] as int? ?? 1,
      height: json['height'] as int? ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dashboard_id': dashboardId,
      'widget_type': widgetType,
      'title': title,
      'config': config,
      'position_x': positionX,
      'position_y': positionY,
      'width': width,
      'height': height,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
