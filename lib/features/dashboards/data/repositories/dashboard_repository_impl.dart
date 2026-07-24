import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/dashboards/data/datasources/dashboard_remote_data_source.dart';
import 'package:issues_tracking/features/dashboards/data/models/dashboard_model.dart';
import 'package:issues_tracking/features/dashboards/data/models/dashboard_widget_model.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';
import 'package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Dashboard>>> getDashboards() async {
    try {
      final dashboards = await remoteDataSource.getDashboards();
      return Right(dashboards);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Dashboard>> createDashboard(String name) async {
    try {
      final dashboard = await remoteDataSource.createDashboard(name);
      return Right(dashboard);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Dashboard>> updateDashboard(Dashboard dashboard) async {
    try {
      final model = DashboardModel(
        id: dashboard.id,
        name: dashboard.name,
        ownerId: dashboard.ownerId,
        isDefault: dashboard.isDefault,
        isFavorite: dashboard.isFavorite,
        layoutConfig: dashboard.layoutConfig,
        createdAt: dashboard.createdAt,
        updatedAt: dashboard.updatedAt,
      );
      final updated = await remoteDataSource.updateDashboard(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDashboard(String id) async {
    try {
      await remoteDataSource.deleteDashboard(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DashboardWidget>>> getWidgets(String dashboardId) async {
    try {
      final widgets = await remoteDataSource.getWidgets(dashboardId);
      return Right(widgets);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardWidget>> addWidget(DashboardWidget widget) async {
    try {
      final model = DashboardWidgetModel(
        id: widget.id,
        dashboardId: widget.dashboardId,
        widgetType: widget.widgetType,
        title: widget.title,
        config: widget.config,
        positionX: widget.positionX,
        positionY: widget.positionY,
        width: widget.width,
        height: widget.height,
        createdAt: widget.createdAt,
        updatedAt: widget.updatedAt,
      );
      final created = await remoteDataSource.addWidget(model);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardWidget>> updateWidget(DashboardWidget widget) async {
    try {
      final model = DashboardWidgetModel(
        id: widget.id,
        dashboardId: widget.dashboardId,
        widgetType: widget.widgetType,
        title: widget.title,
        config: widget.config,
        positionX: widget.positionX,
        positionY: widget.positionY,
        width: widget.width,
        height: widget.height,
        createdAt: widget.createdAt,
        updatedAt: widget.updatedAt,
      );
      final updated = await remoteDataSource.updateWidget(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeWidget(String widgetId) async {
    try {
      await remoteDataSource.removeWidget(widgetId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWidgetsPositions(List<DashboardWidget> widgets) async {
    try {
      final models = widgets.map((widget) => DashboardWidgetModel(
        id: widget.id,
        dashboardId: widget.dashboardId,
        widgetType: widget.widgetType,
        title: widget.title,
        config: widget.config,
        positionX: widget.positionX,
        positionY: widget.positionY,
        width: widget.width,
        height: widget.height,
        createdAt: widget.createdAt,
        updatedAt: widget.updatedAt,
      )).toList();
      await remoteDataSource.updateWidgetsPositions(models);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
