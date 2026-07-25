import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_bloc.dart';
import 'package:issues_tracking/features/dashboards/presentation/bloc/dashboard_event.dart';
import 'package:issues_tracking/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/dashboards/presentation/pages/dashboard_page.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/youtrack_shell.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_view_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_settings_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_list_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_template_selection_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_template_details_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/create_project_form_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/add_project_members_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_members_page.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_general_settings_section.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart';
import 'package:issues_tracking/features/custom_fields/presentation/pages/custom_fields_settings_section.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/custom_fields_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_creation_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';
import 'package:issues_tracking/features/auth/presentation/pages/login_page.dart';

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
///       ├── /projects/:projectId/add-members   ← AddProjectMembersPage
///       └── /projects/:projectId/members       ← ProjectMembersPage
/// ```
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
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<DashboardBloc>()..add(LoadDashboards())),
            BlocProvider(create: (_) => sl<IssuesBloc>()..add(const LoadIssues())),
            BlocProvider(create: (_) => sl<YouTrackShellCubit>()),
          ],
          child: YouTrackShell(navigationShell: navigationShell),
        ),
        branches: [
          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                          Issues Branch                            ║
          // ╚════════════════════════════════════════════════════════════════════╝
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.issues,
                builder: (context, state) => const IssuesPage(),
              ),
            ],
          ),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                        Dashboard Branch                           ║
          // ╚════════════════════════════════════════════════════════════════════╝
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                       Agile Boards Branch                          ║
          // ╚════════════════════════════════════════════════════════════════════╝
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.agileBoards,
                builder: (context, state) => Container(),
              ),
            ],
          ),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                         Reports Branch                             ║
          // ╚════════════════════════════════════════════════════════════════════╝
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteKeys.reports,
                builder: (context, state) => Container(),
              ),
            ],
          ),

          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                        Projects Branch                             ║
          // ╚════════════════════════════════════════════════════════════════════╝
          _projectsBranch(),
        ],
      ),
    ],
  );

  
  static StatefulShellBranch _projectsBranch() {
    return StatefulShellBranch(
      routes: [
        ShellRoute(
          builder: (context, state, child) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<ProjectsListCubit>()),
              BlocProvider(create: (_) => sl<ProjectCreationCubit>()),
              BlocProvider(create: (_) => sl<ProjectDetailsCubit>()),
              BlocProvider(create: (_) => sl<ProjectMembersCubit>()),
            ],
            child: child,
          ),
          routes: [
            // ── Projects List ────────────────────────────────────────
            GoRoute(
              path: AppRouteKeys.projects,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProjectsListPage(),
                transitionsBuilder: _fadeTransition,
              ),
              routes: [
                // ── Template Selection ────────────────────────────────
                GoRoute(
                  path: 'templates',
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const ProjectTemplateSelectionPage(),
                    transitionsBuilder: _fadeTransition,
                  ),
                  routes: [
                    // ── Template Details ────────────────────────────
                    GoRoute(
                      path: ':templateId',
                      redirect: (context, state) {
                        final templateId = state.pathParameters['templateId'];
                        if (templateId == null || templateId.isEmpty) {
                          return AppRouteKeys.projectTemplates;
                        }
                        return null;
                      },
                      pageBuilder: (context, state) {
                        final templateId = state.pathParameters['templateId']!;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: ProjectTemplateDetailsPage(
                            templateId: templateId,
                          ),
                          transitionsBuilder: _fadeTransition,
                        );
                      },
                    ),
                  ],
                ),

                // ── Create Project Form ────────────────────────────────
                GoRoute(
                  path: 'new',
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const CreateProjectFormPage(),
                    transitionsBuilder: _fadeTransition,
                  ),
                ),

                // ── Project Details ────────────────────────────────────
                GoRoute(
                  path: ':projectId',
                  redirect: (context, state) {
                    final projectId = state.pathParameters['projectId'];
                    if (projectId == null || projectId.isEmpty) {
                      return AppRouteKeys.projects;
                    }
                    return null;
                  },
                  pageBuilder: (context, state) {
                    final projectId = state.pathParameters['projectId']!;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: ProjectView(projectId: projectId),
                      transitionsBuilder: _fadeTransition,
                    );
                  },
                  routes: [
                    // ── Add Project Members ────────────────────────
                    GoRoute(
                      path: 'add-members',
                      redirect: (context, state) {
                        final projectId = state.pathParameters['projectId'];
                        if (projectId == null || projectId.isEmpty) {
                          return AppRouteKeys.projects;
                        }
                        return null;
                      },
                      pageBuilder: (context, state) {
                        final projectId = state.pathParameters['projectId']!;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: AddProjectMembersPage(projectId: projectId),
                          transitionsBuilder: _fadeTransition,
                        );
                      },
                    ),

                    // ── Project Members ────────────────────────────
                    GoRoute(
                      path: 'members',
                      redirect: (context, state) {
                        final projectId = state.pathParameters['projectId'];
                        if (projectId == null || projectId.isEmpty) {
                          return AppRouteKeys.projects;
                        }
                        return null;
                      },
                      pageBuilder: (context, state) {
                        final projectId = state.pathParameters['projectId']!;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: ProjectMembersPage(projectId: projectId),
                          transitionsBuilder: _fadeTransition,
                        );
                      },
                    ),

                    // ── Project Settings ────────────────────────────
                    ShellRoute(
                      builder: (context, state, child) {
                        final projectId = state.pathParameters['projectId']!;
                        return ProjectSettingsPage(
                          projectId: projectId,
                          child: child,
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'settings',
                          redirect: (context, state) {
                            final projectId = state.pathParameters['projectId'];
                            return AppRouteKeys.projectSettingsSectionPath(
                              projectId!,
                              AppRouteKeys.projectSettingsGeneral,
                            );
                          },
                        ),
                        GoRoute(
                          path: 'settings/general',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const ProjectGeneralSettingsSection(),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/people',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const ProjectPeopleSettingsSection(),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/custom-fields',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: BlocProvider<CustomFieldsCubit>(
                              create: (_) => sl<CustomFieldsCubit>(),
                              child: const CustomFieldsSettingsSection(),
                            ),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/vcs',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(child: Text('Version Control Settings')),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/notifications',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(child: Text('Notifications Settings')),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/builds',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(child: Text('Build Servers Settings')),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/time',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(child: Text('Time Tracking Settings')),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/workflows',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(child: Text('Workflows Settings')),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/apps',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(child: Text('Apps Settings')),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// انتقال Fade بمدة 200ms (مطابق للـ AnimatedSwitcher الأصلي)
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
