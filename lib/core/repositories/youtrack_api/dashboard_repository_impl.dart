import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';
import 'package:issues_tracking/core/repositories/abstractions/dashboard_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardsApi _api;

  DashboardRepositoryImpl(this._api);

  @override
  Future<Either<Failure, DashboardWidget>> addWidget(
    DashboardWidget widget,
  ) async {
    final result = await _api.addWidget(
      widget.dashboardId,
      _widgetToJson(widget),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_widgetFromJson(result.data));
  }

  @override
  Future<Either<Failure, Dashboard>> createDashboard(String name) async {
    final result = await _api.createDashboard(name);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_dashboardFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteDashboard(String id) async {
    final result = await _api.deleteDashboard(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Dashboard>>> getDashboards() async {
    final result = await _api.getDashboards();
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_dashboardFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<DashboardWidget>>> getWidgets(
    String dashboardId,
  ) async {
    final result = await _api.getWidgets(dashboardId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_widgetFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> removeWidget(String widgetId) async {
    final result = await _api.removeWidget(widgetId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, Dashboard>> updateDashboard(
    Dashboard dashboard,
  ) async {
    final result = await _api.updateDashboard(
      dashboard.id,
      _dashboardToJson(dashboard),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_dashboardFromJson(result.data));
  }

  @override
  Future<Either<Failure, DashboardWidget>> updateWidget(
    DashboardWidget widget,
  ) async {
    final result = await _api.updateWidget(widget.id, _widgetToJson(widget));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_widgetFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> updateWidgetsPositions(
    List<DashboardWidget> widgets,
  ) async {
    final result = await _api.updateWidgetPositions(
      widgets.map(_widgetToJson).toList(growable: false),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }
}

Dashboard _dashboardFromJson(JsonObject json) => Dashboard(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] ?? '').toString(),
  ownerId: (json['ownerId'] ?? json['owner_id'] ?? '').toString(),
  isDefault: json['isDefault'] == true || json['is_default'] == true,
  isFavorite: json['isFavorite'] == true || json['is_favorite'] == true,
  layoutConfig: json['layoutConfig'] is Map
      ? Map<String, dynamic>.from(json['layoutConfig'] as Map)
      : const {},
  createdAt: _date(json['createdAt'] ?? json['created_at']),
  updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
);

JsonObject _dashboardToJson(Dashboard dashboard) => {
  'name': dashboard.name,
  'ownerId': dashboard.ownerId,
  'isDefault': dashboard.isDefault,
  'isFavorite': dashboard.isFavorite,
  'layoutConfig': dashboard.layoutConfig,
};

DashboardWidget _widgetFromJson(JsonObject json) => DashboardWidget(
  id: (json['id'] ?? '').toString(),
  dashboardId: (json['dashboardId'] ?? json['dashboard_id'] ?? '').toString(),
  widgetType: (json['widgetType'] ?? json['widget_type'] ?? '').toString(),
  title: (json['title'] ?? '').toString(),
  config: json['config'] is Map
      ? Map<String, dynamic>.from(json['config'] as Map)
      : const {},
  positionX: _int(json['positionX'] ?? json['position_x']),
  positionY: _int(json['positionY'] ?? json['position_y']),
  width: _int(json['width'], fallback: 1),
  height: _int(json['height'], fallback: 1),
  createdAt: _date(json['createdAt'] ?? json['created_at']),
  updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
);

JsonObject _widgetToJson(DashboardWidget widget) => {
  'id': widget.id,
  'dashboardId': widget.dashboardId,
  'widgetType': widget.widgetType,
  'title': widget.title,
  'config': widget.config,
  'positionX': widget.positionX,
  'positionY': widget.positionY,
  'width': widget.width,
  'height': widget.height,
};

int _int(Object? value, {int fallback = 0}) =>
    int.tryParse(value?.toString() ?? '') ?? fallback;

DateTime _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
