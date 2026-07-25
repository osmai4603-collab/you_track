import 'package:flutter/material.dart';

class ProjectIcon extends StatelessWidget {
  final String projectCode;
  final double size;
  final double fontSize;

  const ProjectIcon({
    super.key,
    required this.projectCode,
    this.size = 40,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shortKey = projectCode.length > 3 ? projectCode.substring(0, 3).toUpperCase() : projectCode.toUpperCase();

    return SizedBox(
      height: size,
      width: size,
      child: Card(
        color: colors.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size * 0.1)),
        margin: EdgeInsets.zero,
        child: Column(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  shortKey,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.tertiary,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: size * 0.2,
              decoration: BoxDecoration(
                color: colors.tertiary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(size * 0.15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
