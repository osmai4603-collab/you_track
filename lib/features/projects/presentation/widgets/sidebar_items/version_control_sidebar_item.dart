import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class VersionControlSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const VersionControlSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Version Control',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
