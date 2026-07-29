import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/issue_state_chip.dart';
import 'package:issues_tracking/core/widgets/issue_priority_chip.dart';
import 'package:issues_tracking/features/app/presentation/cubit/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/priority_icon.dart';

class IssuesListView extends StatelessWidget {
  const IssuesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
            itemCount: state.filteredIssues.length,
            itemBuilder: (context, index) {
              final issue = state.filteredIssues[index];
              return _IssueListCard(
                issue: issue,
                isSelected: state.selectedIssueId == issue.id,
                isMultiSelected: state.selectedIssueIds.contains(issue.id),
                onTap: () {
                  context.read<IssuesBloc>().add(SelectIssue(issue.id));
                },
                onCheckboxChanged: () {
                  context.read<IssuesBloc>().add(
                    ToggleIssueSelection(issue.id),
                  );
                },
                onStarToggle: () {
                  context.read<IssuesBloc>().add(ToggleStarIssue(issue.id));
                },
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _IssueListCard extends StatelessWidget {
  final Issue issue;
  final bool isSelected;
  final bool isMultiSelected;
  final VoidCallback onTap;
  final VoidCallback onCheckboxChanged;
  final VoidCallback onStarToggle;

  const _IssueListCard({
    required this.issue,
    required this.isSelected,
    required this.isMultiSelected,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.onStarToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.extraSmall,
      ),
      child: Material(
        color: isSelected
            ? colors.primaryContainer.withValues(alpha: 0.2)
            : colors.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.3)
                    : colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Checkbox(
                        value: isMultiSelected,
                        onChanged: (_) => onCheckboxChanged(),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        activeColor: colors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),

                    IssuePriorityChip(
                      type: issue.priority,
                      localization: localization,
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    GestureDetector(
                      onTap: () {
                        context.read<YouTrackShellCubit>().setCurrentIssue(
                          issue,
                        );
                        context.go('/issues/${issue.id}/edit');
                      },
                      child: Text(
                        issue.issueKey,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontFamily: 'JetBrains Mono',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    IssueStateChip(
                      state: issue.state,
                      textTheme: textTheme,
                      colors: colors,
                      localization: localization,
                    ),
                    const Spacer(),
                    Text(
                      issue.issueType.displayName(localization),
                      style: textTheme.labelSmall,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    GestureDetector(
                      onTap: onStarToggle,
                      child: Icon(
                        issue.isStarred ? Icons.star : Icons.star_border,
                        size: 16,
                        color: issue.isStarred
                            ? Colors.amber
                            : colors.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  issue.summary,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (issue.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    issue.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.small),
                Row(
                  children: [
                    ...issue.tags
                        .take(4)
                        .map(
                          (tag) => Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.extraSmall,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryContainer.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag.name,
                                style: textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                    const Spacer(),
                    if (issue.assigneeName != null) ...[
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colors.primaryContainer,
                        child: Text(
                          issue.assigneeName![0].toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.onPrimaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        issue.assigneeName!,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                    ],
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${issue.commentsCount}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Icon(
                      Icons.attach_file,
                      size: 14,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${issue.attachmentsCount}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      _formatRelativeTime(issue.updatedAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else {
      return '${(diff.inDays / 365).floor()}y ago';
    }
  }
}
