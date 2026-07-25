import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class GeneralSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const GeneralSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'General',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
