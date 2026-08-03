import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/theme/app_text_theme.dart';
import 'package:issues_tracking/core/widgets/text_hover_widget.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_card.dart';

class BoardCardWidget extends StatelessWidget {
  final BoardCard card;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final AppLocalizations localization;

  const BoardCardWidget({
    super.key,
    required this.card,
    this.isHighlighted = false,
    this.onTap,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final priorityColor = _getPriorityColor(card.priority.name, colors);

    final cardContent = Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isHighlighted
            ? colors.secondaryContainer.withValues(alpha: 0.18)
            : colors.surfaceContainerLowest,
        borderRadius: AppRadius.smallBorderRadius,
        border: Border.all(
          color: isHighlighted ? colors.secondary : colors.outline,
          width: isHighlighted ? 1.6 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: colors.secondary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.smallBorderRadius,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: priorityColor, width: 4)),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: AppSpacing.paddingAllMedium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.issueKey,
                              style: AppTextTheme.light.labelLarge?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              card.summary,
                              style: AppTextTheme.light.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (card.assigneeAvatarUrl != null)
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            card.assigneeAvatarUrl!,
                          ),
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.person_add_rounded),
                          padding: .all(1),
                          onPressed: () {},
                        ),

                      Row(
                        spacing: 4,
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(card.priority.color),
                          ),
                          TextHoverWidget(
                            text: card.priority.displayName(localization),
                            style: textTheme.labelSmall!,
                            styleHover: textTheme.labelSmall!.copyWith(
                              color: colors.secondary,
                            ),
                          ),
                        ],
                      ),

                      TextHoverWidget(
                        text: card.issueType.displayName(localization),
                        style: textTheme.labelSmall!,
                        styleHover: textTheme.labelSmall!.copyWith(
                          color: colors.secondary,
                        ),
                      ),

                      TextHoverWidget(
                        text: card.subsystem.name,
                        style: textTheme.labelSmall!,
                        styleHover: textTheme.labelSmall!.copyWith(
                          color: colors.secondary,
                        ),
                      ),

                      TextHoverWidget(
                        text: card.assigneeName ?? 'Unassignee',
                        style: textTheme.labelSmall!,
                        styleHover: textTheme.labelSmall!.copyWith(
                          color: colors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.account_tree_outlined,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      TextHoverWidget(
                        text: '${card.completedSubtasks}/${card.totalSubtasks}',
                        style: AppTextTheme.light.labelSmall!.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        styleHover: AppTextTheme.light.labelSmall!.copyWith(
                          color: colors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Draggable<BoardCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(
            width: 280, // Approx width of the column
            child: cardContent,
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: cardContent),
      child: cardContent,
    );
  }

  Color _getPriorityColor(String priority, ColorScheme colors) {
    switch (priority.toLowerCase()) {
      case 'show_stopper':
      case 'showstopper':
        return colors.error;
      case 'critical':
        return Colors.orange;
      case 'major':
        return Colors.amber;
      case 'normal':
        return Colors.green;
      case 'minor':
        return Colors.blue;
      default:
        return colors.outline;
    }
  }
}
