import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';

class Dashboard extends Entity {
  final String id;
  final String name;
  final String ownerId;
  final bool isDefault;
  final bool isFavorite;
  final Map<String, dynamic> layoutConfig;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DashboardWidget>
  widgets; // For convenience, though might not be stored in same table

  const Dashboard({
    required this.id,
    required this.name,
    required this.ownerId,
    this.isDefault = false,
    this.isFavorite = false,
    this.layoutConfig = const {},
    required this.createdAt,
    required this.updatedAt,
    this.widgets = const [],
  });

  @override
  Dashboard copyWith({
    String? id,
    String? name,
    String? ownerId,
    bool? isDefault,
    bool? isFavorite,
    Map<String, dynamic>? layoutConfig,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<DashboardWidget>? widgets,
  }) {
    return Dashboard(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      isDefault: isDefault ?? this.isDefault,
      isFavorite: isFavorite ?? this.isFavorite,
      layoutConfig: layoutConfig ?? this.layoutConfig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      widgets: widgets ?? this.widgets,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ownerId,
    isDefault,
    isFavorite,
    layoutConfig,
    createdAt,
    updatedAt,
    widgets,
  ];
}
