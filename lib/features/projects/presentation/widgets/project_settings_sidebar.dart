import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'project_settings_sidebar_header.dart';
import 'sidebar_items/general_sidebar_item.dart';
import 'sidebar_items/people_sidebar_item.dart';
import 'sidebar_items/custom_fields_sidebar_item.dart';
import 'sidebar_items/version_control_sidebar_item.dart';
import 'sidebar_items/notifications_sidebar_item.dart';
import 'sidebar_items/build_servers_sidebar_item.dart';
import 'sidebar_items/time_tracking_sidebar_item.dart';
import 'sidebar_items/workflows_sidebar_item.dart';
import 'sidebar_items/apps_sidebar_item.dart';

class ProjectSettingsSidebar extends StatelessWidget {
  final String projectId;
  final int selectedIndex;

  const ProjectSettingsSidebar({
    super.key,
    required this.projectId,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, state) {
        final project = state.project;
        final projectName = project?.name ?? 'Loading...';
        final projectKey = project?.projectKey ?? '...';
        final owner = project?.owner ?? 'admin';
        final createdAt = project?.createdAt ?? DateTime.now();

        return Container(
          width: 220,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: colors.outlineVariant, width: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProjectSettingsSidebarHeader(
                projectName: projectName,
                projectCode: projectKey,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                  ),
                  children: [
                    GeneralSidebarItem(
                      isSelected: selectedIndex == 0,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsGeneral(projectId),
                      ),
                    ),
                    PeopleSidebarItem(
                      isSelected: selectedIndex == 1,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsPeople(projectId),
                      ),
                    ),
                    CustomFieldsSidebarItem(
                      isSelected: selectedIndex == 2,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsCustomFields(projectId),
                      ),
                    ),
                    VersionControlSidebarItem(
                      isSelected: selectedIndex == 3,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsVersionControl(projectId),
                      ),
                    ),
                    NotificationsSidebarItem(
                      isSelected: selectedIndex == 4,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsNotifications(projectId),
                      ),
                    ),
                    BuildServersSidebarItem(
                      isSelected: selectedIndex == 5,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsBuildServers(projectId),
                      ),
                    ),
                    TimeTrackingSidebarItem(
                      isSelected: selectedIndex == 6,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsTimeTracking(projectId),
                      ),
                    ),
                    WorkflowsSidebarItem(
                      isSelected: selectedIndex == 7,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsWorkflows(projectId),
                      ),
                    ),
                    AppsSidebarItem(
                      isSelected: selectedIndex == 8,
                      onTap: () => context.go(
                        AppRouteKeys.projectSettingsApps(projectId),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(text: 'Owned by '),
                          TextSpan(
                            text: owner,
                            style: TextStyle(color: colors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Created on ${DateFormat('MMM dd, yyyy').format(createdAt)}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
