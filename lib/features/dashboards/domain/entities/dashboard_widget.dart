import 'package:issues_tracking/core/entities/entity.dart';

class DashboardWidget extends Entity {
  final String id;
  final String dashboardId;
  final String widgetType;
  final String title;
  final Map<String, dynamic> config;
  final int positionX;
  final int positionY;
  final int width;
  final int height;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardWidget({
    required this.id,
    required this.dashboardId,
    required this.widgetType,
    required this.title,
    this.config = const {},
    this.positionX = 0,
    this.positionY = 0,
    this.width = 1,
    this.height = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  DashboardWidget copyWith({
    String? id,
    String? dashboardId,
    String? widgetType,
    String? title,
    Map<String, dynamic>? config,
    int? positionX,
    int? positionY,
    int? width,
    int? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DashboardWidget(
      id: id ?? this.id,
      dashboardId: dashboardId ?? this.dashboardId,
      widgetType: widgetType ?? this.widgetType,
      title: title ?? this.title,
      config: config ?? this.config,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    dashboardId,
    widgetType,
    title,
    config,
    positionX,
    positionY,
    width,
    height,
    createdAt,
    updatedAt,
  ];
}
