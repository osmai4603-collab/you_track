import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';

class FieldTableHeader extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final ValueChanged<bool?>? onSelectAll;
  final bool showDetails;

  const FieldTableHeader({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    this.onSelectAll,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: selectedCount == totalCount && totalCount > 0
                  ? true
                  : selectedCount > 0
                      ? null
                      : false,
              tristate: true,
              onChanged: onSelectAll,
            ),
          ),
          const SizedBox(width: 8),
          const SizedBox(width: 32),
          Expanded(
            flex: 3,
            child: Text(
              'Field in Projects',
              style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Type',
              style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Default Value(s)',
              style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (showDetails) ...[
            Expanded(
              flex: 2,
              child: Text(
                'Empty Value',
                style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Can Be Empty',
                style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Value Mode',
                style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Default Visibility in Issues List',
                style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
