import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<Dashboard>>> getDashboards();
  Future<Either<Failure, Dashboard>> createDashboard(String name);
  Future<Either<Failure, Dashboard>> updateDashboard(Dashboard dashboard);
  Future<Either<Failure, void>> deleteDashboard(String id);
  
  Future<Either<Failure, List<DashboardWidget>>> getWidgets(String dashboardId);
  Future<Either<Failure, DashboardWidget>> addWidget(DashboardWidget widget);
  Future<Either<Failure, DashboardWidget>> updateWidget(DashboardWidget widget);
  Future<Either<Failure, void>> removeWidget(String widgetId);
  
  // Custom updates
  Future<Either<Failure, void>> updateWidgetsPositions(List<DashboardWidget> widgets);
}
