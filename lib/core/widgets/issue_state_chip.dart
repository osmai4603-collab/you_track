import 'package:flutter/material.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

class IssueStateChip extends StatelessWidget {
  final IssueStateEnum state;
  final TextTheme textTheme;
  final AppLocalizations localization;
  final ColorScheme colors;

  const IssueStateChip({
    super.key,
    required this.state,
    required this.textTheme,
    required this.colors,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color(state.color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        state.displayName(localization),
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
