import 'package:flutter/material.dart';
import '../project_settings_sidebar_item.dart';

class NotificationsSidebarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const NotificationsSidebarItem({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProjectSettingsSidebarItem(
      label: 'Notifications',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
