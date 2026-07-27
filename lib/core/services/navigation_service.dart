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
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issue_form.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_view_page.dart';
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
            BlocProvider(
              create: (_) => sl<DashboardBloc>()..add(LoadDashboards()),
            ),
            BlocProvider(
              create: (_) => sl<IssuesBloc>()..add(const LoadIssues()),
            ),
            BlocProvider(create: (_) => sl<YouTrackShellCubit>()),
          ],
          child: YouTrackShell(navigationShell: navigationShell),
        ),
        branches: [
          // ╔════════════════════════════════════════════════════════════════════╗
          // ║                          Issues Branch                            ║
          // ╚════════════════════════════════════════════════════════════════════╝
          _issuesBranch(),

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

  static StatefulShellBranch _issuesBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRouteKeys.issues,
          builder: (context, state) {
            return const IssuesPage();
          },
          routes: [
            GoRoute(
              path: 'new-issue',
              pageBuilder: (_, state) {
                final projectKey =
                    state.uri.queryParameters['project'] ?? 'DEM';
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => IssueFormCubit(repository: sl()),
                    child: IssueForm(projectKey: projectKey),
                  ),
                  transitionsBuilder: _fadeTransition,
                );
              },
            ),
            GoRoute(
              path: ':issueId/edit',
              pageBuilder: (_, state) {
                final issueId = state.pathParameters['issueId']!;
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => IssueFormCubit(repository: sl()),
                    child: IssueForm(issueId: issueId),
                  ),
                  transitionsBuilder: _fadeTransition,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

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

                    // ── Knowledge Base ────────────────────────────
                    GoRoute(
                      path: 'knowledge-base',
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
                          child: KnowledgeBasePage(projectId: projectId),
                          transitionsBuilder: _fadeTransition,
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'new',
                          pageBuilder: (context, state) {
                            final projectId =
                                state.pathParameters['projectId']!;
                            return CustomTransitionPage(
                              key: state.pageKey,
                              child: ArticleEditorPage(projectId: projectId),
                              transitionsBuilder: _fadeTransition,
                            );
                          },
                        ),
                        GoRoute(
                          path: ':articleId',
                          redirect: (context, state) {
                            final articleId = state.pathParameters['articleId'];
                            if (articleId == null || articleId.isEmpty) {
                              return AppRouteKeys.projectKnowledgeBasePath(
                                state.pathParameters['projectId']!,
                              );
                            }
                            return null;
                          },
                          pageBuilder: (context, state) {
                            final projectId =
                                state.pathParameters['projectId']!;
                            final articleId =
                                state.pathParameters['articleId']!;
                            return CustomTransitionPage(
                              key: state.pageKey,
                              child: ArticleEditorPage(
                                projectId: projectId,
                                articleId: articleId,
                              ),
                              transitionsBuilder: _fadeTransition,
                            );
                          },
                        ),
                      ],
                    ),

                    // ── Time Tracking ────────────────────────────
                    GoRoute(
                      path: 'time-tracking',
                      pageBuilder: (context, state) {
                        final projectId = state.pathParameters['projectId']!;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: TimeTrackingPage(projectId: projectId),
                          transitionsBuilder: _fadeTransition,
                        );
                      },
                    ),

                    // ── VCS Changes ──────────────────────────────
                    GoRoute(
                      path: 'vcs-changes',
                      pageBuilder: (context, state) {
                        final projectId = state.pathParameters['projectId']!;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: BlocProvider<VcsIntegrationsCubit>(
                            create: (_) => sl<VcsIntegrationsCubit>(),
                            child: VcsChangesPage(projectId: projectId),
                          ),
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
                            return AppRouteKeys.projectSettingsGeneral(
                              projectId!,
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
                            child: BlocProvider<VcsIntegrationsCubit>(
                              create: (_) => sl<VcsIntegrationsCubit>(),
                              child: const VersionControlSettingsSection(),
                            ),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/notifications',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(
                              child: Text('Notifications Settings'),
                            ),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/builds',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(
                              child: Text('Build Servers Settings'),
                            ),
                            transitionsBuilder: _fadeTransition,
                          ),
                        ),
                        GoRoute(
                          path: 'settings/time',
                          pageBuilder: (context, state) {
                            final projectId =
                                state.pathParameters['projectId']!;
                            return CustomTransitionPage(
                              key: state.pageKey,
                              child: BlocProvider<TimeTrackingConfigCubit>(
                                create: (_) => sl<TimeTrackingConfigCubit>(),
                                child: ProjectTimeTrackingSettingsSection(
                                  projectId: projectId,
                                ),
                              ),
                              transitionsBuilder: _fadeTransition,
                            );
                          },
                        ),
                        GoRoute(
                          path: 'settings/workflows',
                          pageBuilder: (context, state) => CustomTransitionPage(
                            key: state.pageKey,
                            child: const Center(
                              child: Text('Workflows Settings'),
                            ),
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
