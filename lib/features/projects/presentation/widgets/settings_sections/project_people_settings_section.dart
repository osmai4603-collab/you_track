import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/avatar_url_chip.dart';
import 'package:issues_tracking/core/widgets/hover_widget.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

const _roleColors = <String, Color>{
  'System Admin': Color(0xFFE65100),
  'Contributor': Color(0xFF00897B),
  'Project Admin': Color(0xFFF57C00),
};

class ProjectPeopleSettingsSection extends StatefulWidget {
  const ProjectPeopleSettingsSection({super.key});

  @override
  State<ProjectPeopleSettingsSection> createState() =>
      _ProjectPeopleSettingsSectionState();
}

class _ProjectPeopleSettingsSectionState
    extends State<ProjectPeopleSettingsSection> {
  final _localMembers = <String, List<String>>{};
  String? _selectedRoleFilter;
  final Set<String> _selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<ProjectMembersCubit>().loadMembers(projectId);
    }
  }

  List<ProjectMemberEntity> _getLocalMembers(
    List<ProjectMemberEntity> members,
  ) {
    return members.map((m) {
      final localRoles = _localMembers[m.id];
      if (localRoles != null) {
        return m.copyWith(roles: localRoles);
      }
      return m;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, projectState) {
        final project = projectState.project;
        final isAdmin = true;

        // ignore: dead_code
        if (!isAdmin) {
          return _buildAccessDeniedView(l10n, textTheme);
        }

        context.watch<GroupsBloc>();

        return BlocBuilder<ProjectMembersCubit, ProjectMembersState>(
          builder: (context, state) {
            final projectId = project?.id ?? '';

            final groupsState = context.read<GroupsBloc>().state;
            List<GroupEntity> projectGroups = [];
            if (groupsState is GroupsLoaded) {
              projectGroups = groupsState.groups
                  .where((g) => g.projects.any((p) => p.projectId == projectId))
                  .toList();
            }

            final members = _getLocalMembers(state.members);
            final query = state.searchQuery.toLowerCase();
            final filteredUsers = members.where((m) {
              final matchesSearch =
                  m.name.toLowerCase().contains(query) ||
                  m.email.toLowerCase().contains(query);
              final matchesRole =
                  _selectedRoleFilter == null ||
                  m.roles.contains(_selectedRoleFilter);
              return matchesSearch && matchesRole;
            }).toList();

            final filteredGroups = projectGroups.where((g) {
              final matchesSearch = g.name.toLowerCase().contains(query);
              final matchesRole =
                  _selectedRoleFilter == null ||
                  g.roles.any(
                    (r) =>
                        r.projectId == projectId &&
                        r.roleName == _selectedRoleFilter,
                  );
              return matchesSearch && matchesRole;
            }).toList();

            final teamMembers = filteredUsers
                .where((m) => m.roles.isNotEmpty)
                .toList();
            final otherPeople = filteredUsers
                .where((m) => m.roles.isEmpty)
                .toList();

            Widget content;
            if (state.status == ProjectMembersStatus.loading) {
              content = Center(
                key: const ValueKey('project-people-loading'),
                child: SizedBox(
                  width: 480,
                  child: ShimmerLoading.list(itemCount: 6),
                ),
              );
            } else if (state.status == ProjectMembersStatus.failure) {
              content = Padding(
                key: const ValueKey('project-people-error'),
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Center(
                  child: SelectableText(
                    state.errorMessage ?? '',
                    style: textTheme.textTheme.bodySmall?.copyWith(
                      color: colors.error,
                    ),
                  ),
                ),
              );
            } else if (teamMembers.isEmpty &&
                otherPeople.isEmpty &&
                filteredGroups.isEmpty) {
              content = _buildEmptyState(l10n, textTheme, colors);
            } else {
              content = SingleChildScrollView(
                key: const ValueKey('project-people-loaded'),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchFilterBar(
                      l10n,
                      textTheme,
                      colors,
                      filteredGroups,
                      projectId,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _buildProjectTeamHeader(
                      teamMembers.length + filteredGroups.length,
                      project?.ownerId ?? '',
                      l10n,
                      textTheme,
                      colors,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Builder(
                      builder: (context) {
                        final mainTableIds = [
                          ...filteredGroups.map((g) => g.id),
                          ...teamMembers.map((m) => m.id),
                        ];
                        final allSelected =
                            mainTableIds.isNotEmpty &&
                            mainTableIds.every(
                              (id) => _selectedItemIds.contains(id),
                            );
                        return _buildMembersTableHeader(
                          textTheme,
                          colors,
                          allSelected: allSelected,
                          onSelectAll: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedItemIds.addAll(mainTableIds);
                              } else {
                                _selectedItemIds.removeAll(mainTableIds);
                              }
                            });
                          },
                        );
                      },
                    ),
                    ...filteredGroups.map(
                      (g) =>
                          _buildGroupRow(g, projectId, l10n, textTheme, colors),
                    ),
                    ...teamMembers.map(
                      (m) => _buildMemberRow(m, l10n, textTheme, colors),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    _buildOtherPeopleSection(
                      otherPeople,
                      l10n,
                      textTheme,
                      colors,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                  ],
                ),
              );
            }

            return AnimatedContentSwitcher(child: content);
          },
        );
      },
    );
  }

  Widget _buildAccessDeniedView(AppLocalizations l10n, ThemeData textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.extraLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: AppSpacing.medium),
            Text(
              l10n.accessDeniedTitle,
              style: textTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              l10n.accessDeniedBody,
              style: textTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilterBar(
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
    List<GroupEntity> filteredGroups,
    String projectId,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              context.read<ProjectMembersCubit>().updateSearchQuery(value);
            },
            decoration: InputDecoration(
              hintText: l10n.searchMembersHint,
              prefixIcon: IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () {},
              ),
              suffixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: AppRadius.smallBorderRadius,
                borderSide: BorderSide(color: colors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.smallBorderRadius,
                borderSide: BorderSide(color: colors.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
            ),
          ),
        ),
        if (_selectedItemIds.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.medium),
          ElevatedButton.icon(
            onPressed: () {
              _showBulkRemoveConfirmation(
                l10n,
                textTheme,
                colors,
                filteredGroups,
                projectId,
              );
            },
            icon: const Icon(Icons.person_remove),
            label: Text(l10n.removeMemberAction),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorContainer,
              foregroundColor: colors.onErrorContainer,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProjectTeamHeader(
    int count,
    String owner,
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    return Row(
      children: [
        Text(
          l10n.projectTeamTitle,
          style: textTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: AppRadius.extraSmallBorderRadius,
          ),
          child: Text(
            '$count',
            style: textTheme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        PopupMenuButton<String>(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Text(
                  owner.isNotEmpty ? owner[0].toUpperCase() : '?',
                  style: textTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.extraSmall),
              Text(owner, style: textTheme.textTheme.bodySmall),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
          onSelected: (_) {},
          itemBuilder: (context) => [
            PopupMenuItem(value: owner, child: Text(owner)),
          ],
        ),
        const SizedBox(width: AppSpacing.medium),
        PopupMenuButton<String>(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.teamRolesLabel, style: textTheme.textTheme.bodySmall),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
          onSelected: (value) {
            setState(() {
              _selectedRoleFilter = value == 'all' ? null : value;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'all', child: Text('All')),
            const PopupMenuItem(
              value: 'System Admin',
              child: Text('System Admin'),
            ),
            const PopupMenuItem(
              value: 'Contributor',
              child: Text('Contributor'),
            ),
            const PopupMenuItem(
              value: 'Project Admin',
              child: Text('Project Admin'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersTableHeader(
    ThemeData textTheme,
    ColorScheme colors, {
    required bool allSelected,
    required ValueChanged<bool?> onSelectAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: CheckboxListTile(
        value: allSelected,
        onChanged: onSelectAll,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        visualDensity: VisualDensity.compact,
        dense: true,
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Name',
                style: textTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Roles',
                style: textTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(
    ProjectMemberEntity member,
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    final initials = member.name.isNotEmpty
        ? member.name.split(' ').map((e) => e[0]).take(2).join()
        : '?';
    final avatarColor =
        _roleColors[member.roles.isNotEmpty ? member.roles.first : ''] ??
        colors.primaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.extraSmall),
      child: CheckboxListTile(
        value: _selectedItemIds.contains(member.id),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedItemIds.add(member.id);
            } else {
              _selectedItemIds.remove(member.id);
            }
          });
        },
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        visualDensity: VisualDensity.compact,
        dense: true,
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: avatarColor,
                    child: Text(
                      initials,
                      style: textTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                member.name,
                                style: textTheme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (member.isOwner) ...[
                              const SizedBox(width: AppSpacing.extraSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius:
                                      AppRadius.extraSmallBorderRadius,
                                ),
                                child: Text(
                                  l10n.projectOwnerBadge,
                                  style: textTheme.textTheme.labelSmall
                                      ?.copyWith(
                                        color: Colors.green.shade700,
                                        fontSize: 9,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          member.email,
                          style: textTheme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
                  return _buildRoleChip(role, textTheme, colors);
                }).toList(),
              ),
            ),
            if (!member.isOwner)
              _buildMemberContextMenu(member, l10n, textTheme, colors)
            else
              const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role, ThemeData textTheme, ColorScheme colors) {
    final chipColor = _roleColors[role] ?? Colors.grey.shade600;

    return HoverWidget(
      builder: (context, isHovered) {
        return InkWell(
          onTap: () => context.go(AppRouteKeys.roles),
          borderRadius: AppRadius.extraSmallBorderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isHovered
                  ? chipColor.withValues(alpha: 0.2)
                  : chipColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.extraSmallBorderRadius,
              border: Border.all(color: chipColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  role,
                  style: textTheme.textTheme.labelSmall?.copyWith(
                    color: chipColor,
                    fontSize: 11,
                  ),
                ),
                if (isHovered)
                  Icon(Icons.open_in_new, size: 12, color: chipColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.extraLarge),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: AppSpacing.medium),
            Text(
              l10n.emptyMembersTitle,
              style: textTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherPeopleSection(
    List<ProjectMemberEntity> people,
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    if (people.isEmpty) return const SizedBox.shrink();

    final otherTableIds = people.map((m) => m.id).toList();
    final allSelected =
        otherTableIds.isNotEmpty &&
        otherTableIds.every((id) => _selectedItemIds.contains(id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.otherPeopleAccessTitle,
          style: textTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        _buildMembersTableHeader(
          textTheme,
          colors,
          allSelected: allSelected,
          onSelectAll: (value) {
            setState(() {
              if (value == true) {
                _selectedItemIds.addAll(otherTableIds);
              } else {
                _selectedItemIds.removeAll(otherTableIds);
              }
            });
          },
        ),
        ...people.map((m) => _buildMemberRow(m, l10n, textTheme, colors)),
      ],
    );
  }

  Widget _buildMemberContextMenu(
    ProjectMemberEntity member,
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 18, color: Colors.grey.shade600),
      onSelected: (value) {
        if (value == 'remove') {
          _showRemoveConfirmation(member, l10n, textTheme, colors);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'remove',
          child: Text(
            l10n.removeMemberAction,
            style: TextStyle(color: colors.error),
          ),
        ),
      ],
    );
  }

  void _showRemoveConfirmation(
    ProjectMemberEntity member,
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeMemberConfirmTitle),
        content: Text(l10n.removeMemberConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _localMembers.remove(member.id);
              });
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.removeMemberAction,
              style: TextStyle(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showBulkRemoveConfirmation(
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
    List<GroupEntity> filteredGroups,
    String projectId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeMemberConfirmTitle),
        content: Text(l10n.removeMemberConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              final groupIds = filteredGroups.map((g) => g.id).toSet();
              setState(() {
                for (final id in _selectedItemIds.toList()) {
                  if (groupIds.contains(id)) {
                    context.read<GroupsBloc>().add(
                      RemoveGroupRoleEvent(groupId: id, projectId: projectId),
                    );
                  } else {
                    _localMembers.remove(id);
                  }
                }
                _selectedItemIds.clear();
              });
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.removeMemberAction,
              style: TextStyle(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupRow(
    GroupEntity group,
    String projectId,
    AppLocalizations l10n,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    final groupRoleInfo = group.roles
        .where((r) => r.projectId == projectId)
        .firstOrNull;
    final groupRole = groupRoleInfo?.roleName ?? 'Contributor';
    final avatarColor = _roleColors[groupRole] ?? colors.primaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.extraSmall),
      child: CheckboxListTile(
        value: _selectedItemIds.contains(group.id),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedItemIds.add(group.id);
            } else {
              _selectedItemIds.remove(group.id);
            }
          });
        },
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        visualDensity: VisualDensity.compact,
        dense: true,
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  AvatarUrlChip(
                    avatarUrl: group.avatarUrl,
                    backColor: avatarColor,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: textTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Group',
                          style: textTheme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Wrap(
                spacing: AppSpacing.extraSmall,
                runSpacing: AppSpacing.extraSmall,
                children: [_buildGroupRoleChip(groupRole, textTheme, colors)],
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupRoleChip(
    String role,
    ThemeData textTheme,
    ColorScheme colors,
  ) {
    final chipColor = _roleColors[role] ?? Colors.grey.shade600;

    return HoverWidget(
      builder: (context, isHovered) {
        return InkWell(
          onTap: () => context.go(AppRouteKeys.roles),
          borderRadius: AppRadius.extraSmallBorderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isHovered
                  ? chipColor.withValues(alpha: 0.2)
                  : chipColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.extraSmallBorderRadius,
              border: Border.all(color: chipColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  role,
                  style: textTheme.textTheme.labelSmall?.copyWith(
                    color: chipColor,
                    fontSize: 11,
                  ),
                ),
                if (isHovered)
                  Icon(Icons.open_in_new, size: 12, color: chipColor),
              ],
            ),
          ),
        );
      },
    );
  }
}
