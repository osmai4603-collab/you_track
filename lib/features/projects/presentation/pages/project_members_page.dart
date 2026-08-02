import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import '../cubits/project_members_cubit.dart';

/// صفحة 7: إدارة أعضاء الفريق والأدوار للمشروع
class ProjectMembersPage extends StatefulWidget {
  final String projectId;

  const ProjectMembersPage({super.key, required this.projectId});

  @override
  State<ProjectMembersPage> createState() => _ProjectMembersPageState();
}

class _ProjectMembersPageState extends State<ProjectMembersPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectMembersCubit>().loadMembers(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ProjectsHeader(
        //   breadcrumbs: [
        //     BreadcrumbItem(title: localization.projectsTitle),
        //     BreadcrumbItem(title: 'People'),
        //   ],
        //   trailing: FilledButton.icon(
        //     onPressed: () => AddProjectMembersPage.show(context, projectId: widget.projectId),
        //     icon: const Icon(AppIcons.personAdd, size: 16),
        //     label: Text(localization.addPeopleButton),
        //   ),
        // ),
        // ── القائمة ──────────────────────────────────
        Expanded(
          child: BlocBuilder<ProjectMembersCubit, ProjectMembersState>(
            builder: (context, state) {
              if (state.status == ProjectMembersStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              // قراءة المجموعات المرتبطة بالمشروع
              final groupsState = context.read<GroupsBloc>().state;
              List<GroupEntity> projectGroups = [];
              if (groupsState is GroupsLoaded) {
                projectGroups = groupsState.groups.where((g) => g.projects.any((p) => p.projectId == widget.projectId)).toList();
              }

              final teamMembers = state.members
                  .where((m) => m.isOwner || m.roles.contains('Project Admin'))
                  .toList();
              final otherMembers = state.members
                  .where(
                    (m) => !m.isOwner && !m.roles.contains('Project Admin'),
                  )
                  .toList();

              return ListView(
                padding: AppSpacing.paddingAllMedium,
                children: [
                  // فريق المشروع
                  if (teamMembers.isNotEmpty || projectGroups.isNotEmpty) ...[
                    Text(
                      localization.projectTeamTitle,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    // عرض المجموعات ككيانات
                    ...projectGroups.map(
                      (group) => _buildGroupTile(group, widget.projectId, colors, textTheme),
                    ),
                    ...teamMembers.map(
                      (member) => _buildMemberTile(
                        member.name,
                        member.email,
                        member.roles,
                        member.isOwner,
                        colors,
                        textTheme,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                  ],
                  // أشخاص آخرون
                  if (otherMembers.isNotEmpty) ...[
                    Text(
                      localization.otherPeopleAccessTitle,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    ...otherMembers.map(
                      (member) => _buildMemberTile(
                        member.name,
                        member.email,
                        member.roles,
                        member.isOwner,
                        colors,
                        textTheme,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemberTile(
    String name,
    String email,
    List<String> roles,
    bool isOwner,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      padding: AppSpacing.paddingAllSmall,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.smallBorderRadius,
      ),
      child: Row(
        children: [
          // أفاتار
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primaryContainer,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: textTheme.labelMedium?.copyWith(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          // الاسم والبريد
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: AppSpacing.small),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.extraSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.tertiaryContainer,
                          borderRadius: AppRadius.extraSmallBorderRadius,
                        ),
                        child: Text(
                          'project owner',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.onTertiaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  email,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // الأدوار
          Wrap(
            spacing: AppSpacing.extraSmall,
            children: roles.map((role) {
              return Chip(
                label: Text(role),
                labelStyle: textTheme.labelSmall?.copyWith(fontSize: 10),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTile(
    GroupEntity group,
    String projectId,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    final groupRoleInfo = group.roles.where((r) => r.projectId == projectId).firstOrNull;
    final role = groupRoleInfo?.roleName ?? 'Contributor';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      padding: AppSpacing.paddingAllSmall,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.smallBorderRadius,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primaryContainer,
            child: Icon(Icons.group, size: 20, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Group',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: AppSpacing.extraSmall,
            children: [
              Chip(
                label: Text(role),
                labelStyle: textTheme.labelSmall?.copyWith(fontSize: 10),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )
            ],
          ),
        ],
      ),
    );
  }
}
