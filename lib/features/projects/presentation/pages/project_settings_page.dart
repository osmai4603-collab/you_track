import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import '../widgets/projects_breadcrumb_header.dart';
import '../widgets/project_settings_sidebar.dart';

class ProjectSettingsPage extends StatefulWidget {
  final String projectId;
  final Widget child;

  const ProjectSettingsPage({
    super.key,
    required this.projectId,
    required this.child,
  });

  @override
  State<ProjectSettingsPage> createState() => _ProjectSettingsPageState();
}

class _ProjectSettingsPageState extends State<ProjectSettingsPage> {
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.endsWith('/general')) return 0;
    if (location.endsWith('/people')) return 1;
    if (location.endsWith('/custom-fields')) return 2;
    if (location.endsWith('/vcs')) return 3;
    if (location.endsWith('/notifications')) return 4;
    if (location.endsWith('/builds')) return 5;
    if (location.endsWith('/time')) return 6;
    if (location.endsWith('/workflows')) return 7;
    if (location.endsWith('/apps')) return 8;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    context.read<ProjectDetailsCubit>().loadProject(widget.projectId);
  }

  String _getSectionTitle(int index) {
    switch (index) {
      case 0:
        return 'General';
      case 1:
        return 'People';
      case 2:
        return 'Custom Fields';
      case 3:
        return 'Version Control';
      case 4:
        return 'Notifications';
      case 5:
        return 'Build Servers';
      case 6:
        return 'Time Tracking';
      case 7:
        return 'Workflows';
      case 8:
        return 'Apps';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedIndex = _getSelectedIndex(context);

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, state) {
        final projectName = state.project?.name ?? '...';

        return Row(
          children: [
            ProjectSettingsSidebar(
              projectId: widget.projectId,
              selectedIndex: selectedIndex,
            ),
            const VerticalDivider(thickness: 1, width: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.large),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}
