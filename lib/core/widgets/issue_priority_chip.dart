import 'package:flutter/material.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

class IssuePriorityChip extends StatelessWidget {
  final IssuePriorityTypeEnum type;
  final TextTheme textTheme;
  final AppLocalizations localization;
  final ColorScheme colors;

  const IssuePriorityChip({
    super.key,
    required this.type,
    required this.textTheme,
    required this.colors,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color(type.color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.displayName(localization)[0],
        style: textTheme.labelSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
