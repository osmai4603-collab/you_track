import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';

import 'project_icon.dart';

class ProjectSettingsSidebarHeader extends StatelessWidget {
  final String projectName;
  final String projectCode;

  const ProjectSettingsSidebarHeader({
    super.key,
    required this.projectName,
    required this.projectCode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppRadius.medium,
      ),
      child: Row(
        spacing: AppSpacing.small,
        children: [
          ProjectIcon(
            projectCode: projectCode,
            size: 50,
            fontSize: 12,
          ),
          Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              Text(
                projectCode.toUpperCase(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
