import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/issue_priority_chip.dart';
import 'package:issues_tracking/core/widgets/text_hover_widget.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/priority_icon.dart';

class IssueTableRow extends StatefulWidget {
  final Issue issue;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;
  final AppLocalizations localization;

  const IssueTableRow({
    super.key,
    required this.issue,
    required this.isSelected,
    required this.isHighlighted,
    required this.onTap,
    required this.localization,
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
    final localization = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.extraSmall,
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
                width: 100,
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.isSelected,
                      onChanged: (_) {
                        context.read<IssuesBloc>().add(
                          ToggleIssueSelection(issue.id),
                        );
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      activeColor: colors.primary,
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context.go('/issues/${issue.id}/edit'),
                      child: TextHoverWidget(
                        text: issue.issueKey,
                        style: textTheme.labelMedium!.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        styleHover: textTheme.labelMedium!.copyWith(
                          color: colors.secondary,

                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.secondary,
                          decorationThickness: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  spacing: 8,
                  children: [
                    IssuePriorityChip(
                      type: issue.priority,
                      localization: localization,
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    Expanded(
                      child: Text(
                        issue.summary,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: TextHoverWidget(
                  text: issue.state.displayName(widget.localization),
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: .w600,
                    color: colors.primary,
                  ),
                  styleHover: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.secondary,
                    decoration: TextDecoration.underline,
                    decorationColor: colors.secondary,
                    decorationThickness: 0.70,
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Flexible(
                      child: TextHoverWidget(
                        text: issue.issueType.displayName(widget.localization),
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: .w600,
                          color: colors.primary,
                        ),
                        styleHover: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.secondary,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.secondary,
                          decorationThickness: 0.70,
                        ),
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
                            child: TextHoverWidget(
                              text: issue.assigneeName ?? 'Unassigned',
                              style: textTheme.bodyMedium!.copyWith(
                                fontWeight: .w600,
                                color: colors.primary,
                              ),
                              styleHover: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colors.secondary,
                                decoration: TextDecoration.underline,
                                decorationColor: colors.secondary,
                                decorationThickness: 0.70,
                              ),
                            ),
                          ),
                        ],
                      )
                    : TextHoverWidget(
                        text: issue.assigneeName ?? 'Unassigned',
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: .w600,
                          color: colors.primary,
                        ),
                        styleHover: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.secondary,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.secondary,
                          decorationThickness: 0.70,
                        ),
                      ),
              ),
              SizedBox(
                width: 110,
                child: Text(
                  _formatRelativeTime(issue.createdAt),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextHoverWidget(
                  text: issue.priority.displayName(localization),
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: .w500,
                    color: colors.primary,
                  ),
                  styleHover: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.secondary,
                    decoration: TextDecoration.underline,
                    decorationColor: colors.secondary,
                    decorationThickness: 0.70,
                  ),
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
