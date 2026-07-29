import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/settings_sections/project_time_tracking_settings_section.dart';

class TimeTrackingPage extends StatelessWidget {
  final String projectId;

  const TimeTrackingPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => get_it<ProjectDetailsCubit>()..loadProject(projectId),
        ),
        BlocProvider(create: (_) => get_it<TimeTrackingConfigCubit>()),
      ],
      child: ProjectTimeTrackingSettingsSection(projectId: projectId),
    );
  }
}
