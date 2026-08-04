import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/enums/project_widget_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
import 'package:issues_tracking/core/widgets/permission_guard.dart';
import 'package:issues_tracking/core/widgets/youtrack_state.dart';
import 'package:issues_tracking/features/app/presentation/cubit/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/breadcrumbs.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/core/widgets/issue_card_tooltip.dart';
import 'package:issues_tracking/features/projects/presentation/pages/add_project_members_page.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import '../../../../core/constants/app_spacing.dart';

class YouTrackContentHeader extends StatelessWidget {
  const YouTrackContentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final shellState = context.watch<YouTrackShellCubit>().state;
    final currentPath = shellState.currentPath;

    final isVisible = currentPath.startsWith(AppRouteKeys.issues);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isVisible && shellState.issues.isNotEmpty) _SectionOne(),
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

    final remainingIssues = <Issue>[];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              child: Row(
                spacing: 8,
                children: [
                  ...shellState.issues.map((issue) {
                    return _TrackedIssueTile(
                      issue: issue,
                      currentIssue: currentIssue,
                    );
                  }),
                ],
              ),
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
                return AppPopupMenuItem(
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

class _TrackedIssueTile extends StatefulWidget {
  final Issue issue;
  final Issue? currentIssue;

  const _TrackedIssueTile({required this.issue, required this.currentIssue});

  @override
  State<_TrackedIssueTile> createState() => _TrackedIssueTileState();
}

class _TrackedIssueTileState extends YouTrackState<_TrackedIssueTile> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _tileKey = GlobalKey();
  bool _isHoveringTile = false;
  bool _isHoveringOverlay = false;

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;
    final overlay = Overlay.of(context);
    final renderBox = _tileKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final left = position.dx.clamp(8.0, screenWidth - 358.0);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: left,
          top: position.dy + size.height + 6,
          child: MouseRegion(
            onEnter: (_) {
              _isHoveringOverlay = true;
            },
            onExit: (_) {
              _isHoveringOverlay = false;
              _hideTooltipIfNeeded();
            },
            child: Material(
              color: Colors.transparent,
              child: IssueCardTooltip(issue: widget.issue),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideTooltipIfNeeded() {
    if (!_isHoveringTile && !_isHoveringOverlay) {
      _removeTooltip();
    }
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = widget.currentIssue?.id == widget.issue.id;

    return MouseRegion(
      onEnter: (_) {
        _isHoveringTile = true;
        _showTooltip();
      },
      onExit: (_) {
        _isHoveringTile = false;
        _hideTooltipIfNeeded();
      },
      child: SizedBox(
        width: 240,
        child: Material(
          color: isSelected
              ? colors.primaryContainer.withOpacity(0.15)
              : colors.surface,
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
            key: _tileKey,
            tileColor: colors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            dense: true,
            title: Text(
              widget.issue.issueKey,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.primary : colors.onSurface,
              ),
            ),
            trailing: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.read<YouTrackShellCubit>().removeIssue(widget.issue);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            onTap: () {
              context.read<YouTrackShellCubit>().setCurrentIssue(widget.issue);
            },
          ),
        ),
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
            PermissionGuard(
              permission: Permission.projectCreateProject,
              child: _ActionButton(
                onPressed: () => context.go(AppRouteKeys.projectTemplates),
                icon: Icons.add,
                label: 'Create Project',
              ),
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
            PermissionGuard(
              permission: Permission.createIssue,
              child: _ActionButton(
                onPressed: () => context.go(AppRouteKeys.createIssue),
                icon: Icons.add,
                label: 'New Issue',
              ),
            ),
          ],
          if (AppRouteKeys.groups == currentPath) ...[
            PermissionGuard(
              permission: Permission.organizationCreateOrganization,
              child: _ActionButton(
                onPressed: () {},
                icon: Icons.add,
                label: 'New Group',
              ),
            ),
          ],
          if (AppRouteKeys.roles == currentPath) ...[
            PermissionGuard(
              permission: Permission.systemLowLevelAdminWrite,
              child: _ActionButton(
                onPressed: () {
                  context.read<RolesBloc>().add(const SelectRole('new'));
                },
                icon: Icons.add,
                label: 'New Role',
              ),
            ),
          ],
          if (AppRouteKeys.users == currentPath) ...[
            PermissionGuard(
              permission: Permission.userCreateUser,
              child: _ActionButton(
                onPressed: () {},
                icon: Icons.add,
                label: 'New User',
              ),
            ),
          ],
          if (currentPath.contains('agile-boards')) ...[
            _SearchField(hint: 'Filter cards on the boards'),
            const SizedBox(width: 16),
            PermissionGuard(
              permission: Permission.createIssue,
              child: _ActionButton(
                onPressed: () => context.go(AppRouteKeys.createIssue),
                icon: Icons.add,
                label: 'New card',
              ),
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
      duration: const Duration(milliseconds: 2500),
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
