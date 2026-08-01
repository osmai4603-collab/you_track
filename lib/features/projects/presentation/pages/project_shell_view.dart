import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
import 'package:issues_tracking/core/widgets/project_chip.dart';
import 'package:issues_tracking/core/widgets/text_hover_widget.dart';
import 'package:issues_tracking/core/widgets/youtrack_state.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_members_cubit.dart';
import 'package:issues_tracking/core/init_dependencies.dart' show get_it;

class ProjectShellView extends StatefulWidget {
  final String projectId;

  const ProjectShellView({super.key, required this.projectId});

  @override
  State<ProjectShellView> createState() => _ProjectShellViewState();
}

class _ProjectShellViewState extends State<ProjectShellView> {
  late final ProjectMembersCubit _membersCubit;
  late final ProjectDetailsCubit _projectDetailsCubit;
  late final IssuesBloc _issuesBloc;

  @override
  void initState() {
    super.initState();
    _membersCubit = get_it<ProjectMembersCubit>()
      ..loadMembers(widget.projectId);
    _projectDetailsCubit = get_it<ProjectDetailsCubit>()
      ..loadProject(widget.projectId);
    _issuesBloc = get_it<IssuesBloc>()
      ..add(UpdateFilter(IssueFilter(projectFilter: widget.projectId)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _membersCubit),
        BlocProvider.value(value: _projectDetailsCubit),
        BlocProvider.value(value: _issuesBloc),
      ],
      child: Row(
        children: [
          _ProjectViewSideBar(projectId: widget.projectId),
          const VerticalDivider(thickness: 1, width: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                spacing: AppSpacing.extraLarge,
                children: [
                  BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
                    builder: (context, state) {
                      final projectName = state.project?.name ?? 'Loading...';
                      return Row(
                        spacing: AppSpacing.medium,
                        children: [
                          Icon(AppIcons.star, color: Colors.orange, size: 21),
                          Text(
                            projectName,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: Row(
                      spacing: AppSpacing.large,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _InfoCard(
                            title: 'Team Members',
                            child:
                                BlocBuilder<
                                  ProjectMembersCubit,
                                  ProjectMembersState
                                >(
                                  builder: (context, state) {
                                    if (state.status ==
                                        ProjectMembersStatus.loading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (state.status ==
                                        ProjectMembersStatus.failure) {
                                      return Center(
                                        child: SelectableText(
                                          state.errorMessage ??
                                              'Failed to load members',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.error,
                                          ),
                                        ),
                                      );
                                    }
                                    if (state.members.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No members yet',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                        ),
                                      );
                                    }
                                    return _buildMembersList(
                                      state.members,
                                      colors,
                                      textTheme,
                                    );
                                  },
                                ),
                          ),
                        ),
                        Expanded(
                          child: _InfoCard(
                            title: 'Issues',
                            child: BlocBuilder<IssuesBloc, IssuesState>(
                              builder: (context, state) {
                                if (state is IssuesLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (state is IssuesError) {
                                  return Center(
                                    child: SelectableText(
                                      state.message,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colors.error,
                                      ),
                                    ),
                                  );
                                }
                                if (state is IssuesLoaded) {
                                  if (state.filteredIssues.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No issues found',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    );
                                  }
                                  return _buildIssuesList(
                                    state.filteredIssues,
                                    colors,
                                    textTheme,
                                    localization,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
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
      ),
    );
  }

  Widget _buildMembersList(
    List<ProjectMemberEntity> members,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return _VerticalScrollList(
      itemCount: members.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colors.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final member = members[index];
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

  Widget _buildIssuesList(
    List<Issue> issues,
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
  ) {
    return _VerticalScrollList(
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        final stateLetter = issue.state.displayName(localization)[0];
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
                  color: Color(issue.state.color),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    stateLetter,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurface,
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
                      issue.issueKey,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontFamily: 'JetBrains Mono',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        issue.summary,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

class _ProjectViewSideBar extends StatefulWidget {
  final String projectId;
  const _ProjectViewSideBar({required this.projectId});

  @override
  State<_ProjectViewSideBar> createState() => _ProjectViewSideBarState();
}

class _ProjectViewSideBarState extends YouTrackState<_ProjectViewSideBar> {
  final List<_SidebarItem> _sidebarItems = [
    _SidebarItem(
      'Issues',
      AppIcons.issues,
      (projectId) => AppRouteKeys.projectIssuesPath(projectId),
    ),
    _SidebarItem(
      'Agile Board',
      AppIcons.board,
      (projectId) => AppRouteKeys.projectAgileBoardsPath(projectId),
    ),
    _SidebarItem(
      'Gantt Chart',
      AppIcons.ganttChart,
      (projectId) => AppRouteKeys.projectGanttChartPath(projectId),
    ),
    _SidebarItem(
      'Knowledge Base',
      AppIcons.knowledgeBase,
      (projectId) => AppRouteKeys.projectKnowledgeBasePath(projectId),
    ),
    _SidebarItem(
      'Setting',
      AppIcons.settings,
      (projectId) => AppRouteKeys.projectSettingsPath(projectId),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
      child: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          final project = state.project;

          return Column(
            spacing: AppSpacing.small,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: AppSpacing.small,
                children: [
                  ProjectChip(
                    shortKey: project?.projectId ?? '',
                    colors: colors,
                    textTheme: textTheme,
                  ),
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHoverWidget(
                        text: project?.name ?? 'Project',
                        style: textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                        styleHover: textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.secondary,
                        ),
                      ),
                      Text(
                        project?.projectId ?? '...'.toUpperCase(),
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                        vertical: AppSpacing.extraSmall - 2,
                      ),
                      hoverColor: colors.primary.withValues(alpha: 0.10),
                      onTap: () {
                        context.go(item.getRoute(widget.projectId));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VerticalScrollList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  const _VerticalScrollList({
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
  });

  @override
  State<_VerticalScrollList> createState() => _VerticalScrollListState();
}

class _VerticalScrollListState extends State<_VerticalScrollList> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollbar = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_showScrollbar) setState(() => _showScrollbar = true);
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showScrollbar = false);
    });
  }

  void _scrollUp() {
    _scrollController.animateTo(
      (_scrollController.offset - 100).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      (_scrollController.offset + 100).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_up, size: 20),
            onPressed: _scrollUp,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Scroll up',
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: _showScrollbar,
            child: widget.separatorBuilder != null
                ? ListView.separated(
                    controller: _scrollController,
                    itemCount: widget.itemCount,
                    itemBuilder: widget.itemBuilder,
                    separatorBuilder: widget.separatorBuilder!,
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: widget.itemCount,
                    itemBuilder: widget.itemBuilder,
                  ),
          ),
        ),
        SizedBox(
          height: 24,
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_down, size: 20),
            onPressed: _scrollDown,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Scroll down',
          ),
        ),
      ],
    );
  }
}

class _SidebarItem {
  final String label;
  final IconData icon;
  final String Function(String projectId) getRoute;

  const _SidebarItem(this.label, this.icon, this.getRoute);
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
      elevation: 0.20,
      // color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outline),
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
                      borderRadius: BorderRadius.circular(4),
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
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.more_vert),
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
