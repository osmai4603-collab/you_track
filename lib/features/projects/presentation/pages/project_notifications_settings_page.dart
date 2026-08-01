import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
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
