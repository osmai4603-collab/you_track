import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_state.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/priority_icon.dart';

class IssueTableRow extends StatefulWidget {
  final Issue issue;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;

  const IssueTableRow({
    super.key,
    required this.issue,
    required this.isSelected,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  State<IssueTableRow> createState() => _IssueTableRowState();
}

class _IssueTableRowState extends State<IssueTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final issue = widget.issue;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: widget.isHighlighted
                ? colors.primaryContainer.withValues(alpha: 0.2)
                : widget.isSelected
                    ? colors.primaryContainer.withValues(alpha: 0.1)
                    : _isHovered
                        ? colors.onSurface.withValues(alpha: 0.04)
                        : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: (widget.isSelected || _isHovered)
                    ? Checkbox(
                        value: widget.isSelected,
                        onChanged: (_) {
                          context.read<IssuesBloc>().add(
                            ToggleIssueSelection(issue.id),
                          );
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        activeColor: colors.primary,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: AppSpacing.extraSmall),
              SizedBox(
                width: 32,
                child: PriorityIcon(priority: issue.priority),
              ),
              SizedBox(
                width: 90,
                child: Text(
                  issue.fullId,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontFamily: 'JetBrains Mono',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            issue.title,
                            style: textTheme.bodyMedium?.copyWith(
                              color: _isHovered ? colors.primary : colors.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (issue.attachmentsCount > 0) ...[
                          const SizedBox(width: AppSpacing.extraSmall),
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
                        ],
                        if (issue.commentsCount > 0) ...[
                          const SizedBox(width: AppSpacing.small),
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
                        ],
                        if (issue.votes > 0) ...[
                          const SizedBox(width: AppSpacing.small),
                          Icon(
                            Icons.keyboard_arrow_up,
                            size: 14,
                            color: colors.onSurfaceVariant,
                          ),
                          Text(
                            '${issue.votes}',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ...issue.tags.take(3).map((tag) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                        )),
                        if (issue.parentId != null) ...[
                          const SizedBox(width: AppSpacing.extraSmall),
                          Icon(
                            Icons.link,
                            size: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: _StateChip(state: issue.state, textTheme: textTheme),
              ),
              SizedBox(
                width: 80,
                child: Row(
                  children: [
                    Icon(
                      issue.issueType.icon,
                      size: 14,
                      color: issue.issueType.color,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        issue.issueType.label,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                child: issue.assigneeName != null
                    ? Row(
                        children: [
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
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              issue.assigneeName!,
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Unassigned',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  _formatRelativeTime(issue.updatedAt),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
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
                  size: 16,
                  color: issue.isStarred
                      ? Colors.amber
                      : colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}d';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo';
    } else {
      return '${(diff.inDays / 365).floor()}y';
    }
  }
}

class _StateChip extends StatelessWidget {
  final IssueTrackState state;
  final TextTheme textTheme;

  const _StateChip({required this.state, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: state.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        state.label,
        style: textTheme.labelSmall?.copyWith(
          color: state.textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
