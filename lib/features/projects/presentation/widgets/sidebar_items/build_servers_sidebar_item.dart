import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class BuildServersSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const BuildServersSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Build Servers',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
