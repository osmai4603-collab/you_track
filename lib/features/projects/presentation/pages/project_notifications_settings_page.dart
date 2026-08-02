import 'package:flutter/material.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_notifications_settings_section.dart';

class ProjectNotificationsSettingsPage extends StatefulWidget {
  const ProjectNotificationsSettingsPage({super.key});

  @override
  State<ProjectNotificationsSettingsPage> createState() =>
      _ProjectNotificationsSettingsPageState();
}

class _ProjectNotificationsSettingsPageState
    extends State<ProjectNotificationsSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProjectNotificationsSettingsSection(),
    );
  }
}
