import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';

class ProjectSettingsSidebarItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ProjectSettingsSidebarItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      minTileHeight: 25,
      title: Text(
        label,
        style: isSelected ? const TextStyle(fontWeight: FontWeight.bold) : null,
      ),
      selected: isSelected,
      selectedTileColor: colors.primary.withValues(alpha: 0.10),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.extraSmall - 2,
      ),
      hoverColor: colors.primary.withValues(alpha: 0.10),
      onTap: onTap,
    );
  }
}
