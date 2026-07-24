import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/dashboards/domain/usecases/get_dashboards.dart';
import 'package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboards getDashboards;
  final DashboardRepository repository; // Simplified for now

  DashboardBloc({required this.getDashboards, required this.repository})
    : super(DashboardInitial()) {
    on<LoadDashboards>(_onLoadDashboards);
    on<SelectDashboard>(_onSelectDashboard);
    on<LoadWidgets>(_onLoadWidgets);
    on<ReorderWidgets>(_onReorderWidgets);
  }

  Future<void> _onLoadDashboards(
    LoadDashboards event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await getDashboards(params: const NoParams());

    result.fold((failure) => emit(DashboardError(failure.message)), (
      dashboards,
    ) {
      final selected = dashboards.isNotEmpty ? dashboards.first : null;
      emit(
        DashboardLoaded(dashboards: dashboards, selectedDashboard: selected),
      );
      if (selected != null) {
        add(LoadWidgets(selected.id));
      }
    });
  }

  Future<void> _onSelectDashboard(
    SelectDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(
        currentState.copyWith(selectedDashboard: event.dashboard, widgets: []),
      );
      add(LoadWidgets(event.dashboard.id));
    }
  }

  Future<void> _onLoadWidgets(
    LoadWidgets event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final result = await repository.getWidgets(event.dashboardId);

      result.fold(
        (failure) => emit(DashboardError(failure.message)),
        (widgets) => emit(currentState.copyWith(widgets: widgets)),
      );
    }
  }

  void _onReorderWidgets(
    ReorderWidgets event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final widgets = List.of(currentState.widgets);

      int oldIndex = event.oldIndex;
      int newIndex = event.newIndex;
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = widgets.removeAt(oldIndex);
      widgets.insert(newIndex, item);

      // Update local state immediately for smooth UI
      emit(currentState.copyWith(widgets: widgets));

      // Persist to backend
      for (int i = 0; i < widgets.length; i++) {
        // Update positions (example: row index)
        // A more sophisticated grid might need both X and Y
      }
      await repository.updateWidgetsPositions(widgets);
    }
  }
}
