import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Dashboard> dashboards;
  final Dashboard? selectedDashboard;
  final List<DashboardWidget> widgets;
  
  const DashboardLoaded({
    required this.dashboards,
    this.selectedDashboard,
    this.widgets = const [],
  });
  
  DashboardLoaded copyWith({
    List<Dashboard>? dashboards,
    Dashboard? selectedDashboard,
    List<DashboardWidget>? widgets,
  }) {
    return DashboardLoaded(
      dashboards: dashboards ?? this.dashboards,
      selectedDashboard: selectedDashboard ?? this.selectedDashboard,
      widgets: widgets ?? this.widgets,
    );
  }
  
  @override
  List<Object?> get props => [dashboards, selectedDashboard, widgets];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  
  @override
  List<Object?> get props => [message];
}
