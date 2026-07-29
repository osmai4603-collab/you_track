import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/enums/project_widget_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
import 'package:issues_tracking/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/breadcrumbs.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/projects/presentation/pages/add_project_members_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_spacing.dart';

class YouTrackContentHeader extends StatelessWidget {
  const YouTrackContentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final shellState = context.watch<YouTrackShellCubit>().state;
    final currentPath = shellState.currentPath;

    final isVisible =
        currentPath.contains('projects') || currentPath.contains('issues');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isVisible) _SectionOne(),
        _SectionTwo(currentPath: currentPath),
        Divider(thickness: 1),
      ],
    );
  }
}

class _SectionOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shellState = context.watch<YouTrackShellCubit>().state;
    final currentIssue = shellState.currentIssue;
    final issuesState = context.watch<IssuesBloc>().state;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final hasUserIssues = issuesState is IssuesLoaded && currentUserId != null;
    final userIssues = hasUserIssues
        ? issuesState.issues
            .where((issue) => issue.reporterId == currentUserId)
            .toList()
        : <Issue>[];

    if (currentIssue == null && userIssues.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayIssues = userIssues.take(5).toList();
    final remainingIssues = userIssues.skip(5).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (currentIssue != null)
                  Chip(
                    label: Text(
                      currentIssue.issueKey,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade700,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ...displayIssues.map((issue) {
                  return Chip(
                    label: Text(
                      issue.issueKey,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (remainingIssues.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
              tooltip: 'More issues',
              onSelected: (value) {
                // Navigate to issue details if needed
              },
              itemBuilder: (context) => remainingIssues.map((issue) {
                return PopupMenuItem(
                  value: issue.id,
                  child: Text(
                    issue.issueKey,
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _SectionTwo extends StatelessWidget {
  final String currentPath;

  const _SectionTwo({required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    final parts = currentPath.split('/');
    final isIssues = parts.contains('issues');
    final isPeople = parts.contains('people');
    final isProjects =
        currentPath.contains('projects') && !isIssues && !isPeople;
    final projectId = _extractProjectId(currentPath);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Breadcrumbs(path: currentPath)),
          if (!isProjects) const Spacer(),
          if (isProjects) const SizedBox(width: 16),
          if (currentPath == AppRouteKeys.projects) ...[
            _SearchField(hint: 'Filter projects by name or ID'),
            const SizedBox(width: 16),
            _ActionButton(
              onPressed: () => context.go(AppRouteKeys.projectTemplates),
              icon: Icons.add,
              label: 'Create Project',
            ),
          ],
          if (isPeople) ...[
            _ActionButton(
              onPressed: () {
                final projectId = _extractProjectId(currentPath);
                if (projectId != null) {
                  _showAddMemberDialog(context, projectId);
                }
              },
              icon: Icons.person_add,
              label: 'Add People',
            ),
          ],
          if (AppRouteKeys.issues == currentPath) ...[
            _ActionButton(
              onPressed: () => context.go(AppRouteKeys.createIssue),
              icon: Icons.add,
              label: 'New Issue',
            ),
          ],
          if (currentPath.contains('agile-boards')) ...[
            _SearchField(hint: 'Filter cards on the boards'),
            const SizedBox(width: 16),
            _ActionButton(
              onPressed: () => context.go(AppRouteKeys.createIssue),
              icon: Icons.add,
              label: 'New card',
            ),
          ],
          if (projectId != null &&
              AppRouteKeys.projectSettingsWorkflows(projectId) ==
                  currentPath) ...[
            PopupMenuButton<String>(
              onSelected: _onSelectedWorkflow,
              itemBuilder: (context) => [
                AppPopupMenuItem(
                  value: 'attach',
                  child: Text('Attach existing workflow'),
                ),
                AppPopupMenuItem(
                  value: 'javascript',
                  child: Text('Javascript Editor'),
                ),
                AppPopupMenuItem(
                  value: 'constructor',
                  child: Text('Workflow Constructor'),
                ),
                AppPopupMenuItem(
                  value: 'jetbrains',
                  child: Text('Browse Jetbrains Marketplace'),
                ),
                AppPopupMenuItem(
                  value: 'zip_file',
                  child: Text('Upload zip file'),
                ),
              ],
              child: Container(
                padding: .symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary,
                  border: .all(color: colors.outline),
                  borderRadius: .circular(4),
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.createButton,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                    Icon(AppIcons.tag, color: colors.onPrimary),
                  ],
                ),
              ),
            ),
          ],

          if (projectId != null &&
              AppRouteKeys.projectDetailsPath(projectId) == currentPath) ...[
            PopupMenuButton<ProjectWidgetEnum>(
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              onSelected: _onSelectProjectWidget,
              useRootNavigator: true,
              itemBuilder: (context) => [
                AppPopupMenuItem(
                  height: 30,
                  padding: EdgeInsets.zero,
                  value: null,
                  child: TextField(
                    cursorHeight: 16,
                    decoration: InputDecoration(
                      prefixIcon: Icon(AppIcons.search),
                      hintText: 'Filter widgets by name',
                      border: InputBorder.none,

                      enabledBorder: InputBorder.none,
                      constraints: BoxConstraints(
                        maxHeight: 30,
                        maxWidth: 400,
                        minWidth: 400,
                      ),
                      fillColor: colors.surface,
                      filled: true,
                      focusColor: colors.surfaceContainerLowest,
                    ),
                  ),
                ),
                ...ProjectWidgetEnum.values.map((widget) {
                  return AppPopupMenuItem(
                    value: widget,
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.widgets, color: colors.onSurface),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.displayName(AppLocalizations.of(context)!)}      ',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: .w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Js.r.o', style: textTheme.bodySmall),
                            const SizedBox(width: 2),
                            Icon(Icons.info_outline_rounded),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                AppPopupMenuItem(
                  value: null,
                  enabled: false,
                  child: Padding(
                    padding: .symmetric(horizontal: 8.0, vertical: 4),
                    child: Text(
                      'Browse Jetbrains Marketplace',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              borderRadius: .circular(4),
              child: Container(
                padding: .symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: .all(color: colors.outline),
                  borderRadius: .circular(4),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.addWidgetButton,
                      style: textTheme.labelMedium,
                    ),
                    const Icon(AppIcons.moreVert),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle new item creation
              },
              itemBuilder: (context) => [
                AppPopupMenuItem(
                  value: 'new_issue',
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(AppIcons.drafts),
                      Text(AppLocalizations.of(context)!.newIssueOption),
                    ],
                  ),
                ),
                AppPopupMenuItem(
                  value: 'new_article',
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(AppIcons.drafts),
                      Text(AppLocalizations.of(context)!.newArticleOption),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: .symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary,
                  border: .all(color: colors.outline),
                  borderRadius: .circular(4),
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.createButton,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                    Icon(AppIcons.menu, color: colors.onPrimary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _extractProjectId(String path) {
    final segments = path.split('/');
    // Expected pattern: /projects/:projectId/people or /projects/:projectId/settings/...
    if (segments.length >= 3 && segments[1] == 'projects') {
      return segments[2];
    }
    return null;
  }

  void _showAddMemberDialog(BuildContext context, String projectId) {
    AddProjectMembersPage.show(context, projectId: projectId);
  }

  void _onSelectProjectWidget(ProjectWidgetEnum value) {}

  void _onSelectedWorkflow(String value) {}
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      // icon: Icon(icon, size: 16),
      child: Text(label),
    );
  }
}

class _SearchField extends StatefulWidget {
  final String hint;

  const _SearchField({required this.hint});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  static const double _unfocusedWidth = 220;
  static const double _focusedWidth = 320;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _widthAnimation = Tween<double>(
      begin: _unfocusedWidth,
      end: _focusedWidth,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return SizedBox(height: 32, width: _widthAnimation.value, child: child);
      },
      child: TextField(
        focusNode: _focusNode,
        cursorHeight: 18,
        style: TextTheme.of(context).bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.extraSmall,
          ),
        ),
      ),
    );
  }
}
