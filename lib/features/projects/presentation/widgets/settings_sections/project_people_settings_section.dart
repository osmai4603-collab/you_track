import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';

class ProjectPeopleSettingsSection extends StatefulWidget {
  const ProjectPeopleSettingsSection({super.key});

  @override
  State<ProjectPeopleSettingsSection> createState() => _ProjectPeopleSettingsSectionState();
}

class _ProjectPeopleSettingsSectionState extends State<ProjectPeopleSettingsSection> {
  @override
  void initState() {
    super.initState();
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<ProjectMembersCubit>().loadMembers(projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, projectState) {
        final project = projectState.project;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(project?.name ?? '...', project?.projectKey ?? '', colors, textTheme),
              const SizedBox(height: AppSpacing.extraLarge),
              _buildQuickActions(colors, textTheme),
              const SizedBox(height: AppSpacing.extraLarge),
              Text(
                'Team members',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.medium),
              _buildMembersTable(colors, textTheme),
              const SizedBox(height: AppSpacing.extraLarge),
              _buildOwnerSection(project?.owner ?? 'admin', project?.createdAt, colors, textTheme),
              const SizedBox(height: AppSpacing.extraLarge),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String projectName, String projectKey, ColorScheme colors, TextTheme textTheme) {
    final shortKey = projectKey.length > 3 ? projectKey.substring(0, 3).toUpperCase() : projectKey.toUpperCase();

    return Row(
      children: [
        Text(
          projectName,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: AppSpacing.small),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: AppRadius.extraSmallBorderRadius,
          ),
          child: Text(
            shortKey,
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(ColorScheme colors, TextTheme textTheme) {
    final actions = [
      ('People', Icons.people_outline),
      ('Custom Fields', Icons.list_alt),
      ('Workflows', Icons.account_tree_outlined),
      ('Time Tracking', Icons.timer_outlined),
      ('Notifications', Icons.notifications_outlined),
      ('Apps', Icons.apps_outlined),
    ];

    return Wrap(
      spacing: AppSpacing.medium,
      runSpacing: AppSpacing.medium,
      children: actions.map((action) {
        return InkWell(
          onTap: () {},
          borderRadius: AppRadius.smallBorderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.small),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outlineVariant),
              borderRadius: AppRadius.smallBorderRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(action.$2, size: 18, color: colors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.extraSmall),
                Text(action.$1, style: textTheme.labelMedium),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMembersTable(ColorScheme colors, TextTheme textTheme) {
    return Card(
      elevation: 0.20,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mediumBorderRadius,
        side: BorderSide(color: colors.outlineVariant),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Roles',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.large),
            BlocBuilder<ProjectMembersCubit, ProjectMembersState>(
              builder: (context, state) {
                if (state.status == ProjectMembersStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.large),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.status == ProjectMembersStatus.failure) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.large),
                    child: Center(
                      child: Text(
                        state.errorMessage ?? 'Failed to load members',
                        style: textTheme.bodySmall?.copyWith(color: colors.error),
                      ),
                    ),
                  );
                }
                if (state.members.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.extraLarge),
                    child: Center(
                      child: Text(
                        'No team members yet',
                        style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ),
                  );
                }
                return _buildMemberRows(state.members, colors, textTheme);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRows(List<ProjectMemberEntity> members, ColorScheme colors, TextTheme textTheme) {
    return Column(
      children: members.map((member) {
        final initials = member.name.isNotEmpty
            ? member.name.split(' ').map((e) => e[0]).take(2).join()
            : '?';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: colors.primaryContainer,
                      child: Text(
                        initials,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          member.email,
                          style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Wrap(
                  spacing: AppSpacing.extraSmall,
                  runSpacing: AppSpacing.extraSmall,
                  children: member.roles.map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: AppRadius.extraSmallBorderRadius,
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Text(
                        role,
                        style: textTheme.labelSmall?.copyWith(fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (member.isOwner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: AppRadius.extraSmallBorderRadius,
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Owner',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOwnerSection(String owner, DateTime? createdAt, ColorScheme colors, TextTheme textTheme) {
    return Card(
      elevation: 0.20,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mediumBorderRadius,
        side: BorderSide(color: colors.outlineVariant),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            const Icon(Icons.person, size: 40, color: Colors.green),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project owner',
                    style: textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    owner,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (createdAt != null)
                    Text(
                      'Owner since ${_formatDate(createdAt)}',
                      style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: AppRadius.smallBorderRadius,
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Owner',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
