import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/agile_boards/presentation/pages/agile_board_view_page.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/custom_fields_cubit.dart';
import 'package:issues_tracking/features/custom_fields/presentation/pages/custom_fields_settings_section.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/pages/article_editor_page.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/pages/knowledge_base_page.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_creation_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/pages/create_project_form_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_members_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_settings_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_template_details_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_template_selection_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/project_view_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_list_page.dart';
import 'package:issues_tracking/features/projects/presentation/pages/projects_shell_page.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_general_settings_section.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_notifications_settings_section.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_time_tracking_settings_section.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/pages/time_tracking_page.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';
import 'package:issues_tracking/features/version_control/presentation/pages/vcs_changes_page.dart';
import 'package:issues_tracking/features/version_control/presentation/pages/version_control_settings_section.dart';

final class ProjectNavigation extends StatefulShellBranch {
  ProjectNavigation() : super(routes: _routes);

  static final List<RouteBase> _routes = [
    ShellRoute(
      builder: (context, state, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => get_it<ProjectsListCubit>()),
          BlocProvider(create: (_) => get_it<ProjectCreationCubit>()),
          BlocProvider(create: (_) => get_it<ProjectDetailsCubit>()),
          BlocProvider(create: (_) => get_it<ProjectMembersCubit>()),
        ],
        child: ProjectsShellPage(child: child),
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
                      child: ProjectTemplateDetailsPage(templateId: templateId),
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
              routes: _selectedProjectChildren,
            ),
          ],
        ),
      ],
    ),
  ];

  static List<RouteBase> get _selectedProjectChildren {
    return [
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
              final projectId = state.pathParameters['projectId']!;
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
              final projectId = state.pathParameters['projectId']!;
              final articleId = state.pathParameters['articleId']!;
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
              create: (_) => get_it<VcsIntegrationsCubit>(),
              child: VcsChangesPage(projectId: projectId),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),

      // ── Issues ──────────────────────────────────────
      GoRoute(
        path: 'issues',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: IssuesPage(projectId: projectId),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),

      // ── Agile Boards ────────────────────────────────
      GoRoute(
        path: 'agile-boards',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final projectName =
              context.read<ProjectDetailsCubit>().state.project?.name ??
              'Project';
          return CustomTransitionPage(
            key: state.pageKey,
            child: AgileBoardViewPage(
              projectId: projectId,
              projectName: projectName,
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),

      // ── Project Settings ────────────────────────────
      ShellRoute(
        builder: (context, state, child) {
          final projectId = state.pathParameters['projectId']!;
          return ProjectSettingsPage(projectId: projectId, child: child);
        },
        routes: [
          GoRoute(
            path: 'settings',
            redirect: (context, state) {
              final projectId = state.pathParameters['projectId'];
              return AppRouteKeys.projectSettingsGeneral(projectId!);
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
                create: (_) => get_it<CustomFieldsCubit>(),
                child: const ProjectSettingCustomFieldsSection(),
              ),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: 'settings/vcs',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider<VcsIntegrationsCubit>(
                create: (_) => get_it<VcsIntegrationsCubit>(),
                child: const VersionControlSettingsSection(),
              ),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: 'settings/notifications',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProjectNotificationsSettingsSection(),
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
            path: 'settings/time-tracking',
            pageBuilder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return CustomTransitionPage(
                key: state.pageKey,
                child: BlocProvider<TimeTrackingConfigCubit>(
                  create: (_) => get_it<TimeTrackingConfigCubit>(),
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
    ];
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
