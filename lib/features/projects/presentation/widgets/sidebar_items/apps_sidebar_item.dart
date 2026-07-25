import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class AppsSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const AppsSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Apps',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
