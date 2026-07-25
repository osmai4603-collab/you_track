import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_priority.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_state.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_type.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';

class ProjectView extends StatefulWidget {
  final String projectId;

  const ProjectView({super.key, required this.projectId});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  int _selectedIndex = 0;

  final List<_SidebarItem> _sidebarItems = [
    _SidebarItem('Issues', AppIcons.issues, AppRouteKeys.issues),
    _SidebarItem('Agile Board', AppIcons.board, AppRouteKeys.agileBoards),
    _SidebarItem('Gantt Chart', AppIcons.ganttChart, '/gantt-chart'),
    _SidebarItem('Knowledge Base', AppIcons.knowledgeBase, '/knowledge-base'),
    _SidebarItem('Setting', AppIcons.settings, '/settings'),
  ];

  final List<ProjectMemberEntity> _members = [];
  final List<Issue> _issues = [];

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    _members.addAll([
      ProjectMemberEntity(
        id: 'm1',
        projectId: widget.projectId,
        name: 'Omar Khaled',
        email: 'omar@example.com',
        roles: ['Project Admin', 'Developer'],
        isOwner: true,
      ),
      ProjectMemberEntity(
        id: 'm2',
        projectId: widget.projectId,
        name: 'Sara Ali',
        email: 'sara@example.com',
        roles: ['Developer'],
      ),
      ProjectMemberEntity(
        id: 'm3',
        projectId: widget.projectId,
        name: 'Ahmed Hassan',
        email: 'ahmed@example.com',
        roles: ['Designer'],
      ),
      ProjectMemberEntity(
        id: 'm4',
        projectId: widget.projectId,
        name: 'Layla Mahmoud',
        email: 'layla@example.com',
        roles: ['QA'],
      ),
    ]);

    final now = DateTime.now();
    _issues.addAll([
      Issue(
        id: 'yt-1',
        projectKey: 'YT',
        issueNumber: 1,
        title: 'Fix critical login authentication bug',
        state: IssueTrackState.open,
        priority: IssuePriority.critical,
        issueType: IssueType.bug,
        reporterId: 'u1',
        reporterName: 'Omar Khaled',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 5)),
        commentsCount: 3,
        attachmentsCount: 1,
      ),
      Issue(
        id: 'yt-5',
        projectKey: 'YT',
        issueNumber: 5,
        title: 'Design new onboarding flow',
        state: IssueTrackState.inProgress,
        priority: IssuePriority.major,
        issueType: IssueType.feature,
        reporterId: 'u2',
        reporterName: 'Sara Ali',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
        commentsCount: 8,
        attachmentsCount: 3,
      ),
      Issue(
        id: 'yt-8',
        projectKey: 'YT',
        issueNumber: 8,
        title: 'Fix timezone display inconsistency',
        state: IssueTrackState.fixed,
        priority: IssuePriority.minor,
        issueType: IssueType.bug,
        reporterId: 'u3',
        reporterName: 'Ahmed Hassan',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 3)),
        commentsCount: 2,
      ),
      Issue(
        id: 'yt-9',
        projectKey: 'YT',
        issueNumber: 9,
        title: 'Add CSV export functionality',
        state: IssueTrackState.verified,
        priority: IssuePriority.normal,
        issueType: IssueType.feature,
        reporterId: 'u1',
        reporterName: 'Omar Khaled',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 6)),
        commentsCount: 5,
      ),
      Issue(
        id: 'yt-12',
        projectKey: 'YT',
        issueNumber: 12,
        title: 'Improve search algorithm relevance',
        state: IssueTrackState.open,
        priority: IssuePriority.major,
        issueType: IssueType.improvement,
        reporterId: 'u2',
        reporterName: 'Sara Ali',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 1)),
        commentsCount: 4,
        attachmentsCount: 1,
      ),
      Issue(
        id: 'yt-15',
        projectKey: 'YT',
        issueNumber: 15,
        title: 'Fix email notification templates',
        state: IssueTrackState.duplicate,
        priority: IssuePriority.normal,
        issueType: IssueType.bug,
        reporterId: 'u3',
        reporterName: 'Ahmed Hassan',
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 4)),
        commentsCount: 1,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        _buildSidebar(colors, textTheme),
        VerticalDivider(thickness: 1, width: 0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              spacing: AppSpacing.extraLarge,
              children: [
                Row(
                  spacing: AppSpacing.medium,
                  children: [
                    Icon(AppIcons.star, color: Colors.orange, size: 21),
                    Text(
                      'Demo Project',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: Row(
                    spacing: AppSpacing.large,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _InfoCard(
                          title: 'Team Members',
                          child: _buildMembersList(colors, textTheme),
                        ),
                      ),
                      Expanded(
                        child: _InfoCard(
                          title: 'Issues',
                          child: _buildIssuesList(colors, textTheme),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(ColorScheme colors, TextTheme textTheme) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: colors.outlineVariant, width: 0.5),
        ),
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppRadius.medium,
      ),
      child: Column(
        spacing: AppSpacing.small,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: AppSpacing.small,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Card(
                  color: colors.onSurface,
                  shape: RoundedRectangleBorder(borderRadius: .circular(6)),
                  child: Column(
                    spacing: 2,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: .center,
                          child: Text(
                            'DEM',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.tertiary,
                            ),
                          ),
                        ),
                      ),
                      Container(height: 10, 
                      decoration: BoxDecoration(
                        color: colors.tertiary,
                        borderRadius: .vertical(bottom: .circular(8))
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                spacing: 2,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Demo Project',
                    style: TextTheme.of(context).labelLarge?.copyWith(
                      fontWeight: .bold,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    'Demo'.toUpperCase(),
                    style: TextTheme.of(context).labelMedium?.copyWith(
                      fontWeight: .w500,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _sidebarItems.length,
              itemBuilder: (context, index) {
                final item = _sidebarItems[index];
                return ListTile(
                  minTileHeight: 25,
                  title: Text(item.label),
                  contentPadding: .symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.extraSmall - 2,
                  ),
                  hoverColor: colors.primary.withValues(alpha: 0.10),
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    context.go(item.route);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList(ColorScheme colors, TextTheme textTheme) {
    return ListView.separated(
      itemCount: _members.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colors.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final member = _members[index];
        final initials = member.name.isNotEmpty
            ? member.name.split(' ').map((e) => e[0]).take(2).join()
            : '?';
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
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
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      member.email,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (member.isOwner)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Owner',
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIssuesList(ColorScheme colors, TextTheme textTheme) {
    return ListView.builder(
      itemCount: _issues.length,
      itemBuilder: (context, index) {
        final issue = _issues[index];
        final stateLetter = issue.state.label.isNotEmpty
            ? issue.state.label[0]
            : '?';
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.extraSmall,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: issue.state.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: issue.state.textColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    stateLetter,
                    style: textTheme.labelSmall?.copyWith(
                      color: issue.state.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Row(
                  spacing: AppSpacing.extraSmall,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.fullId,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontFamily: 'JetBrains Mono',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      issue.title,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

class _SidebarItem {
  final String label;
  final IconData icon;
  final String route;

  const _SidebarItem(this.label, this.icon, this.route);
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.medium,
            ),

            child: Row(
              spacing: AppSpacing.small,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: colors.secondary),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {},
                      tooltip: 'Refresh',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      padding: AppSpacing.paddingAllSmall,
                      borderRadius: .circular(4),
                      menuPadding: AppSpacing.paddingAllSmall,
                      itemBuilder: (context) => [
                        const AppPopupMenuItem(
                          value: 'clone',
                          child: Text('Clone widget'),
                        ),
                        const AppPopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const AppPopupMenuItem(
                          value: 'remove',
                          child: Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const PopupMenuDivider(),
                        const AppPopupMenuItem(
                          value: 'about',
                          child: Text('About'),
                        ),
                      ],
                      onSelected: (value) {},
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
