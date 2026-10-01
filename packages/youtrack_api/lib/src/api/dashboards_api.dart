import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class DashboardsApi {
  final JsonApi _json;

  DashboardsApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getDashboards() =>
      _json.getObjects('/dashboards');

  Future<ApiResult<JsonObject>> createDashboard(String name) =>
      _json.postObject('/dashboards', data: {'name': name});

  Future<ApiResult<JsonObject>> updateDashboard(
    String dashboardID,
    JsonObject dashboard,
  ) => _json.patchObject(
    '/dashboards/${Uri.encodeComponent(dashboardID)}',
    data: dashboard,
  );

  Future<ApiResult<void>> deleteDashboard(String dashboardID) =>
      _json.deleteVoid('/dashboards/${Uri.encodeComponent(dashboardID)}');

  Future<ApiResult<List<JsonObject>>> getWidgets(String dashboardID) => _json
      .getObjects('/dashboards/${Uri.encodeComponent(dashboardID)}/widgets');

  Future<ApiResult<JsonObject>> addWidget(
    String dashboardID,
    JsonObject widget,
  ) => _json.postObject(
    '/dashboards/${Uri.encodeComponent(dashboardID)}/widgets',
    data: widget,
  );

  Future<ApiResult<JsonObject>> updateWidget(
    String widgetID,
    JsonObject widget,
  ) => _json.patchObject(
    '/dashboard-widgets/${Uri.encodeComponent(widgetID)}',
    data: widget,
  );

  Future<ApiResult<void>> removeWidget(String widgetID) =>
      _json.deleteVoid('/dashboard-widgets/${Uri.encodeComponent(widgetID)}');

  Future<ApiResult<void>> updateWidgetPositions(List<JsonObject> widgets) =>
      _json.putVoid('/dashboard-widgets/order', data: {'widgets': widgets});
}
