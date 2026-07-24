import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_event.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_state.dart';
import 'package:issues_tracking/features/dashboards/presentation/pages/dashboard_page.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/dashboard_sidebar.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';

sealed class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRouteKeys.dashboard,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppRouteKeys.dashboard),
      GoRoute(
        path: AppRouteKeys.login,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Login Screen'))),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BlocProvider(
          create: (_) => sl<DashboardBloc>()..add(LoadDashboards()),
          child: BlocProvider(
            create: (_) => sl<IssuesBloc>()..add(const LoadIssues()),
            child: _ShellLayout(location: state.uri.toString(), child: child),
          ),
        ),
        routes: [
          GoRoute(
            path: AppRouteKeys.issues,
            builder: (context, state) => const IssuesPage(),
          ),
          GoRoute(
            path: AppRouteKeys.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
        ],
      ),
    ],
  );
}

class _ShellLayout extends StatelessWidget {
  final String location;
  final Widget child;

  const _ShellLayout({required this.location, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isIssues = location.startsWith(AppRouteKeys.issues);

    return Scaffold(
      body: Row(
        children: [
          DashboardSidebar(),
          // Container(
          //   width: 250,
          //   color: colors.surfaceContainerHighest,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(AppSpacing.medium),
          //         child: Text(
          //           'YouTrack',
          //           style: textTheme.titleLarge?.copyWith(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       const Divider(height: 1),
          //       _NavItem(
          //         icon: Icons.dashboard_outlined,
          //         label: 'Dashboards',
          //         isSelected: !isIssues,
          //         onTap: () => context.go(AppRouteKeys.dashboard),
          //       ),
          //       _NavItem(
          //         icon: Icons.bug_report_outlined,
          //         label: 'Issues',
          //         isSelected: isIssues,
          //         onTap: () => context.go(AppRouteKeys.issues),
          //       ),
          //       const Divider(height: 1),
          //       Expanded(child: isIssues ? _IssuesList() : _DashboardsList()),
          //     ],
          //   ),
          // ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected ? colors.primaryContainer : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colors.onPrimaryContainer
                        : colors.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.extraSmall,
            ),
            itemCount: state.dashboards.length,
            itemBuilder: (context, index) {
              final dashboard = state.dashboards[index];
              final isSelected = state.selectedDashboard?.id == dashboard.id;
              return Material(
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  title: Text(dashboard.name),
                  selected: isSelected,
                  selectedTileColor: colors.primaryContainer,
                  selectedColor: colors.onPrimaryContainer,
                  trailing: dashboard.isFavorite
                      ? const Icon(Icons.star, color: Colors.orange, size: 16)
                      : null,
                  onTap: () {
                    context.read<DashboardBloc>().add(
                      SelectDashboard(dashboard),
                    );
                  },
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _IssuesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        if (state is IssuesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is IssuesLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.extraSmall,
            ),
            itemCount: state.issues.length,
            itemBuilder: (context, index) {
              final issue = state.issues[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<IssuesBloc>().add(SelectIssue(issue.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.small,
                      vertical: AppSpacing.extraSmall,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: issue.state.textColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.extraSmall),
                            Expanded(
                              child: Text(
                                issue.fullId,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Icon(
                              issue.priority.icon,
                              size: 12,
                              color: issue.priority.color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          issue.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
