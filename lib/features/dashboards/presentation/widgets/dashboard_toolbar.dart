import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_state.dart';

class DashboardToolbar extends StatelessWidget {
  const DashboardToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded && state.selectedDashboard != null) {
          final dashboard = state.selectedDashboard!;
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.large,
              vertical: AppSpacing.medium,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                bottom: BorderSide(color: colors.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                _Breadcrumb(colors: colors, textTheme: textTheme),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
                  child: IconButton(
                    icon: Icon(
                      dashboard.isFavorite ? Icons.star : Icons.star_border,
                      color: dashboard.isFavorite ? Colors.orange : colors.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {},
                    tooltip: 'Toggle favorite',
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add widget'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () {},
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: const Icon(Icons.settings, size: 20),
                  onPressed: () {},
                  tooltip: 'Settings',
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _Breadcrumb({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Dashboards',
          style: textTheme.titleMedium?.copyWith(color: colors.primary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.extraSmall),
          child: Icon(Icons.chevron_right, size: 18, color: colors.onSurfaceVariant),
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoaded && state.selectedDashboard != null) {
              return Text(
                state.selectedDashboard!.name,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
