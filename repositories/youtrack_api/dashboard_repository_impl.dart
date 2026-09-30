import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/dashboards/domain/entities/dashboard.dart';
import 'package:youtrack_frontend/features/dashboards/domain/entities/dashboard_widget.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<Either<Failure, DashboardWidget>> addWidget(DashboardWidget widget) {
    // TODO: implement addWidget
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Dashboard>> createDashboard(String name) {
    // TODO: implement createDashboard
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteDashboard(String id) {
    // TODO: implement deleteDashboard
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Dashboard>>> getDashboards() async {
    return Right([]);
    // TODO: implement getDashboards
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<DashboardWidget>>> getWidgets(
    String dashboardId,
  ) {
    // TODO: implement getWidgets
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeWidget(String widgetId) {
    // TODO: implement removeWidget
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Dashboard>> updateDashboard(Dashboard dashboard) {
    // TODO: implement updateDashboard
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DashboardWidget>> updateWidget(
    DashboardWidget widget,
  ) {
    // TODO: implement updateWidget
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateWidgetsPositions(
    List<DashboardWidget> widgets,
  ) {
    // TODO: implement updateWidgetsPositions
    throw UnimplementedError();
  }
}
