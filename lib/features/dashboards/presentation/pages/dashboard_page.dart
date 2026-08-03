import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
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
              Widget content;

              if (state is DashboardLoading) {
                content = Center(
                  key: const ValueKey('dashboard-loading'),
                  child: SizedBox(width: 480, child: ShimmerLoading.list(itemCount: 6)),
                );
              } else if (state is DashboardError) {
                content = Center(
                  key: const ValueKey('dashboard-error'),
                  child: SelectableText(state.message),
                );
              } else if (state is DashboardLoaded) {
                if (state.selectedDashboard == null) {
                  content = const Center(
                    key: ValueKey('dashboard-empty'),
                    child: Text('No dashboards found. Create one!'),
                  );
                } else {
                  content = const DashboardGrid(key: ValueKey('dashboard-grid'));
                }
              } else {
                content = const SizedBox.shrink(key: ValueKey('dashboard-empty'));
              }

              return AnimatedContentSwitcher(child: content);
            },
          ),
        ),
      ],
    );
  }
}
