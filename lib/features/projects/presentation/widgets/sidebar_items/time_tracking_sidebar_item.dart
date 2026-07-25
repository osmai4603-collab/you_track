import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class TimeTrackingSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const TimeTrackingSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Time Tracking',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
