import 'package:flutter/material.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/hover_widget.dart';
import 'package:issues_tracking/core/widgets/issue_state_chip.dart';
import 'package:issues_tracking/core/widgets/issue_priority_chip.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/project_icon.dart';

class IssueCardTooltip extends StatelessWidget {
  final Issue issue;
  const IssueCardTooltip({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    final localization = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        color: colors.surfaceContainer,
        width: 400,
        padding: .all(16),
        child: Column(
          children: [
            Row(
              children: [
                HoverWidget(
                  builder: (_, isHovered) {
                    return Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.document_scanner_rounded,
                          color: isHovered ? colors.secondary : colors.primary,
                        ),
                        Text(
                          issue.issueKey,
                          style: isHovered
                              ? textTheme.bodySmall?.copyWith(
                                  color: colors.secondary,
                                )
                              : textTheme.bodySmall?.copyWith(
                                  color: colors.primary,
                                ),
                        ),
                      ],
                    );
                  },
                ),
                Text(
                  'Manage user access',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                ),
              ],
            ),
            Divider(height: 24, thickness: 0.80),
            Row(
              spacing: 16,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    ProjectIcon(projectCode: issue.issueKey),
                    Text(issue.issueKey),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    IssuePriorityChip(
                      type: issue.priority,
                      localization: localization,
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    Text(issue.issueKey),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    IssueStateChip(
                      state: issue.state,
                      colors: colors,
                      textTheme: textTheme,
                      localization: localization,
                    ),
                    Text(issue.issueKey),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
