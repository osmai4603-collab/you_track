import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_event.dart';
import 'package:issues_tracking/features/dashboards/presentation/pages/dashboard_page.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/dashboard_sidebar.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_shell_page.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_creation_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';

sealed class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BlocProvider(
          create: (_) => sl<DashboardBloc>()..add(LoadDashboards()),
          child: BlocProvider(
            create: (_) => sl<IssuesBloc>()..add(const LoadIssues()),
            child: _ShellLayout(navigationShell: navigationShell),
          ),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.issues,
                builder: (context, state) => const IssuesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.agileBoards,
                builder: (context, state) => Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.reports,
                builder: (context, state) => Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.projects,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<ProjectsListCubit>()),
                    BlocProvider(create: (_) => sl<ProjectCreationCubit>()),
                    BlocProvider(create: (_) => sl<ProjectDetailsCubit>()),
                    BlocProvider(create: (_) => sl<ProjectMembersCubit>()),
                  ],
                  child: const ProjectsShellPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _ShellLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ShellLayout({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const DashboardSidebar(),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
