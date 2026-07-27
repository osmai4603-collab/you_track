import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/issue_state_chip.dart';
import 'package:issues_tracking/core/widgets/issue_priority_chip.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';

class _TreeNode {
  final Issue issue;
  final List<_TreeNode> children;

  _TreeNode({required this.issue, this.children = const []});
}

class IssuesTreeView extends StatefulWidget {
  const IssuesTreeView({super.key});

  @override
  State<IssuesTreeView> createState() => _IssuesTreeViewState();
}

class _IssuesTreeViewState extends State<IssuesTreeView> {
  final Set<String> _expandedNodes = {};

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        if (state is IssuesLoaded) {
          if (state.filteredIssues.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'No issues found',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    'Try adjusting your search or filters',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          final tree = _buildTree(state.filteredIssues);
          _autoExpandRoots(tree);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tree
                  .map(
                    (node) => _TreeNodeWidget(
                      localization: localization,
                      node: node,
                      depth: 0,
                      expandedNodes: _expandedNodes,
                      onToggle: (id) {
                        setState(() {
                          if (_expandedNodes.contains(id)) {
                            _expandedNodes.remove(id);
                          } else {
                            _expandedNodes.add(id);
                          }
                        });
                      },
                      selectedIssueId: state.selectedIssueId,
                      selectedIssueIds: state.selectedIssueIds,
                    ),
                  )
                  .toList(),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<_TreeNode> _buildTree(List<Issue> issues) {
    final issueMap = {for (final issue in issues) issue.id: issue};
    final childrenMap = <String, List<Issue>>{};

    for (final issue in issues) {
      if (issue.parentId != null && issueMap.containsKey(issue.parentId)) {
        childrenMap.putIfAbsent(issue.parentId!, () => []).add(issue);
      }
    }

    final roots = issues
        .where((i) => i.parentId == null || !issueMap.containsKey(i.parentId))
        .toList();

    return roots.map((issue) => _buildNode(issue, childrenMap)).toList();
  }

  _TreeNode _buildNode(Issue issue, Map<String, List<Issue>> childrenMap) {
    final children = childrenMap[issue.id] ?? [];
    return _TreeNode(
      issue: issue,
      children: children.map((c) => _buildNode(c, childrenMap)).toList(),
    );
  }

  void _autoExpandRoots(List<_TreeNode> tree) {
    for (final node in tree) {
      if (node.children.isNotEmpty && !_expandedNodes.contains(node.issue.id)) {
        _expandedNodes.add(node.issue.id);
      }
    }
  }
}

class _TreeNodeWidget extends StatelessWidget {
  final _TreeNode node;
  final int depth;
  final Set<String> expandedNodes;
  final ValueChanged<String> onToggle;
  final String? selectedIssueId;
  final Set<String> selectedIssueIds;
  final AppLocalizations localization;

  const _TreeNodeWidget({
    required this.node,
    required this.depth,
    required this.expandedNodes,
    required this.onToggle,
    required this.selectedIssueId,
    required this.selectedIssueIds,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final issue = node.issue;
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = expandedNodes.contains(issue.id);
    final isSelected = selectedIssueId == issue.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: isSelected
              ? colors.primaryContainer.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              context.read<IssuesBloc>().add(SelectIssue(issue.id));
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: depth * 24.0,
                right: AppSpacing.small,
                top: AppSpacing.extraSmall,
                bottom: AppSpacing.extraSmall,
              ),
              child: Row(
                children: [
                  if (hasChildren)
                    GestureDetector(
                      onTap: () => onToggle(issue.id),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                    )
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: AppSpacing.extraSmall),

                  IssuePriorityChip(
                    type: issue.priority,
                    localization: localization,
                    textTheme: textTheme,
                    colors: colors,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    issue.issueKey,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontFamily: 'JetBrains Mono',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Text(
                      issue.summary,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IssueStateChip(
                    state: issue.state,
                    textTheme: textTheme,
                    colors: colors,
                    localization: localization,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  if (issue.assigneeName != null)
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: colors.primaryContainer,
                      child: Text(
                        issue.assigneeName![0].toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.extraSmall),
                  GestureDetector(
                    onTap: () {
                      context.read<IssuesBloc>().add(ToggleStarIssue(issue.id));
                    },
                    child: Icon(
                      issue.isStarred ? Icons.star : Icons.star_border,
                      size: 14,
                      color: issue.isStarred
                          ? Colors.amber
                          : colors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          ...node.children.map(
            (child) => _TreeNodeWidget(
              node: child,
              depth: depth + 1,
              expandedNodes: expandedNodes,
              onToggle: onToggle,
              selectedIssueId: selectedIssueId,
              selectedIssueIds: selectedIssueIds,
              localization: localization,
            ),
          ),
      ],
    );
  }
}
