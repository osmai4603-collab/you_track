import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class WorkflowsSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const WorkflowsSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Workflows',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
