import 'package:flutter/material.dart';

class ProjectChip extends StatelessWidget {
  const ProjectChip({
    required this.colors,
    required this.textTheme,
    super.key,
    required this.shortKey,
    this.backColor,
    this.textColor,
  });

  final ColorScheme colors;
  final TextTheme textTheme;
  final Color? backColor;
  final Color? textColor;
  final String shortKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Card(
        color: backColor ?? colors.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Column(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: .all(4),
                alignment: .centerStart,
                child: Text(
                  shortKey,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor ?? colors.tertiary,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: textColor ?? colors.tertiary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
