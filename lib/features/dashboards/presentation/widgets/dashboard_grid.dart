import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_event.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_state.dart';
import 'dashboard_widget_card.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          final widgets = state.widgets;
          if (widgets.isEmpty) {
            return const Center(child: Text('No widgets added yet.'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: ReorderableGridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.medium,
                mainAxisSpacing: AppSpacing.medium,
                childAspectRatio: 1.5,
              ),
              itemCount: widgets.length,
              onReorder: (oldIndex, newIndex) {
                context.read<DashboardBloc>().add(ReorderWidgets(oldIndex, newIndex));
              },
              itemBuilder: (context, index) {
                final widget = widgets[index];
                return DashboardWidgetCard(
                  key: ValueKey(widget.id),
                  widgetEntity: widget,
                  child: _buildWidgetContent(widget.widgetType),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWidgetContent(String type) {
    switch (type) {
      case 'issue_list':
        return const Center(child: Text('Issue List'));
      case 'issue_distribution':
        return const Center(child: Text('Issue Distribution (fl_chart)'));
      default:
        return Center(child: Text('Unknown Widget Type: $type'));
    }
  }
}
