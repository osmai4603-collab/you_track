import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class CustomFieldsSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CustomFieldsSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Custom Fields',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
