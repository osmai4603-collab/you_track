import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_state.dart';
import '../widgets/dashboard_toolbar.dart';
import '../widgets/dashboard_grid.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardToolbar(),
        Expanded(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DashboardError) {
                return Center(child: Text(state.message));
              } else if (state is DashboardLoaded) {
                if (state.selectedDashboard == null) {
                  return const Center(
                    child: Text('No dashboards found. Create one!'),
                  );
                }
                return const DashboardGrid();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
