import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class PeopleSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const PeopleSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'People',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
