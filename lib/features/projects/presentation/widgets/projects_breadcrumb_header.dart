import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';

class BreadcrumbItem {
  final String title;
  final void Function(BuildContext context)? onTap;

  const BreadcrumbItem({required this.title, this.onTap});
}

class ProjectsBreadcrumbHeader extends StatelessWidget {
  final List<BreadcrumbItem> breadcrumbs;
  final Widget? trailing;

  const ProjectsBreadcrumbHeader({
    super.key,
    required this.breadcrumbs,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: _buildBreadcrumbs(context, colors, textTheme),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  List<Widget> _buildBreadcrumbs(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    final widgets = <Widget>[];
    for (int i = 0; i < breadcrumbs.length; i++) {
      final item = breadcrumbs[i];
      final isLast = i == breadcrumbs.length - 1;

      widgets.add(_BreadcrumbText(item: item, isLast: isLast));

      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
            child: Text(
              '/',
              style: textTheme.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }
}

class _BreadcrumbText extends StatefulWidget {
  final BreadcrumbItem item;
  final bool isLast;

  const _BreadcrumbText({required this.item, required this.isLast});

  @override
  State<_BreadcrumbText> createState() => _BreadcrumbTextState();
}

class _BreadcrumbTextState extends State<_BreadcrumbText> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isClickable = widget.item.onTap != null;

    return MouseRegion(
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () => widget.item.onTap?.call(context),
        child: Text(
          widget.item.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: widget.isLast ? FontWeight.w600 : FontWeight.w500,
            color: isClickable ? Colors.red : colors.onSurface,
            decoration: isClickable
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
