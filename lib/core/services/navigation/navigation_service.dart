import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/services/navigation/agile_boards_navigation.dart';
import 'package:issues_tracking/core/services/navigation/dashboard_navigation.dart';
import 'package:issues_tracking/core/services/navigation/issues_navigation.dart';
import 'package:issues_tracking/core/services/navigation/project_navigation.dart';
import 'package:issues_tracking/core/services/navigation/groups_navigation.dart';
import 'package:issues_tracking/core/services/navigation/roles_navigation.dart';
import 'package:issues_tracking/core/services/navigation/users_navigation.dart';
import 'package:issues_tracking/core/services/navigation/report_navigation.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_event.dart';
import 'package:issues_tracking/features/app/presentation/cubit/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/dashboards/presentation/pages/dashboard_page.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';
import 'package:issues_tracking/features/app/presentation/widgets/youtrack_shell.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issue_form.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_shell_view.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_settings_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_list_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_template_selection_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_template_details_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/create_project_form_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_members_page.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_general_settings_section.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart';
import 'package:issues_tracking/features/custom_fields/presentation/pages/custom_fields_settings_section.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/custom_fields_cubit.dart';
import 'package:issues_tracking/features/version_control/presentation/pages/version_control_settings_section.dart';
import 'package:issues_tracking/features/version_control/presentation/pages/vcs_changes_page.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_creation_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_time_tracking_settings_section.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';
import 'package:issues_tracking/features/auth/presentation/pages/login_page.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/pages/knowledge_base_page.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/pages/article_editor_page.dart';
import 'package:issues_tracking/features/time_tracking/presentation/pages/time_tracking_page.dart';

/// **هيكلية المسارات:**
/// ```
/// /login                                       ← Root Navigator (بدون Shell)
/// StatefulShellRoute                           ← MainScreen (Stateful Navigator)
///   ├── Branch: Issues                         ← IssuesPage
///   ├── Branch: Dashboard                      ← DashboardPage
///   ├── Branch: Agile Boards                   ← (قيد التطوير)
///   ├── Branch: Reports                        ← (قيد التطوير)
///   └── Branch: Projects                       ← ShellRoute (MultiBlocProvider)
///       ├── /projects                          ← ProjectsListPage
///       ├── /projects/templates                ← ProjectTemplateSelectionPage
///       ├── /projects/templates/:templateId    ← ProjectTemplateDetailsPage
///       ├── /projects/new                      ← CreateProjectFormPage
///       ├── /projects/:projectId               ← ProjectDetailsPage
///       └── /projects/:projectId/members       ← ProjectMembersPage
/// ```
sealed class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRouteKeys.login,
    refreshListenable: get_it<UserSession>(),
    redirect: (context, state) {
      final isLoggedIn = get_it<UserSession>().isLoggedIn;
      final isLoginRoute = state.matchedLocation == AppRouteKeys.login;

      if (!isLoggedIn && !isLoginRoute) return AppRouteKeys.login;
      if (isLoggedIn && isLoginRoute) return AppRouteKeys.dashboard;
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppRouteKeys.login),
      GoRoute(
        path: AppRouteKeys.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => get_it<DashboardBloc>()..add(LoadDashboards()),
            ),
            BlocProvider(
              create: (_) => get_it<IssuesBloc>()..add(const LoadIssues()),
            ),
            BlocProvider(create: (_) => get_it<GroupsBloc>()),
            BlocProvider(create: (_) => get_it<RolesBloc>()),
            BlocProvider(create: (_) => get_it<UsersBloc>()),
            BlocProvider(create: (_) => get_it<YouTrackShellCubit>()),
          ],
          child: ChangeNotifierProvider.value(
            value: get_it<UserSession>(),
            child: YouTrackShell(navigationShell: navigationShell),
          ),
        ),
        branches: [
          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                          Issues Branch                            ║
          // ╚════════════════════════════════════════════════════════════════════╝
          IssuesNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                        Dashboard Branch                           ║
          // ╚════════════════════════════════════════════════════════════════════╝
          DashboardNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                       Agile Boards Branch                          ║
          // ╚════════════════════════════════════════════════════════════════════╝
          AgileBoardsNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                          Groups Branch                             ║
          // ╚════════════════════════════════════════════════════════════════════╝
          GroupsNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                          Roles Branch                              ║
          // ╚════════════════════════════════════════════════════════════════════╝
          RolesNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                          Users Branch                              ║
          // ╚════════════════════════════════════════════════════════════════════╝
          UsersNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                         Reports Branch                             ║
          // ╚════════════════════════════════════════════════════════════════════╝
          ReportNavigation(),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                        Projects Branch                             ║
          // ╚════════════════════════════════════════════════════════════════════╝
          ProjectNavigation(),
        ],
      ),
    ],
  );
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
