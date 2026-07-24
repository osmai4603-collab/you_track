import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboards extends DashboardEvent {}

class CreateDashboardEvent extends DashboardEvent {
  final String name;
  const CreateDashboardEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class SelectDashboard extends DashboardEvent {
  final Dashboard dashboard;
  const SelectDashboard(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class LoadWidgets extends DashboardEvent {
  final String dashboardId;
  const LoadWidgets(this.dashboardId);

  @override
  List<Object?> get props => [dashboardId];
}

class ReorderWidgets extends DashboardEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderWidgets(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
