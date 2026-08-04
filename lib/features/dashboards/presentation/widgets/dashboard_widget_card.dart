import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard_widget.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';

class DashboardWidgetCard extends StatelessWidget {
  final DashboardWidget widgetEntity;
  final Widget child;

  const DashboardWidgetCard({
    super.key,
    required this.widgetEntity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colors.outlineVariant),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widgetEntity.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {},
                  tooltip: 'Refresh',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  padding: AppSpacing.paddingAllSmall,
                  menuPadding: AppSpacing.paddingAllSmall,
                  itemBuilder: (context) => [
                    const AppPopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit settings'),
                    ),
                    const AppPopupMenuItem(
                      value: 'clone',
                      child: Text('Clone widget'),
                    ),
                    const AppPopupMenuItem(
                      value: 'remove',
                      child: Text('Remove widget'),
                    ),
                  ],
                  onSelected: (value) {},
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
