import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_card.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_column.dart';
import 'package:issues_tracking/features/agile_boards/presentation/widgets/board_card_widget.dart';

class BoardColumnWidget extends StatelessWidget {
  final BoardColumn column;
  final Function(BoardCard card, BoardColumn newColumn) onCardDropped;
  final VoidCallback onAddPressed;

  const BoardColumnWidget({
    super.key,
    required this.column,
    required this.onCardDropped,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localization = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          right: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
          bottom: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: DragTarget<BoardCard>(
        onWillAcceptWithDetails: (details) {
          return details.data.state != column.state;
        },
        onAcceptWithDetails: (details) {
          onCardDropped(details.data, column);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            color: candidateData.isNotEmpty
                ? colors.primaryContainer.withValues(alpha: 0.2)
                : Colors.transparent,
            padding: const EdgeInsets.all(AppSpacing.small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...column.cards.map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.small),
                    child: BoardCardWidget(
                      card: card,
                      localization: localization,
                    ),
                  ),
                ),
                // Add button
                InkWell(
                  onTap: onAddPressed,
                  borderRadius: AppRadius.smallBorderRadius,
                  child: Padding(
                    padding: AppSpacing.paddingAllSmall,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
