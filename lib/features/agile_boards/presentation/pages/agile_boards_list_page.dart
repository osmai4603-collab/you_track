import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/projects_list_cubit.dart';

class AgileBoardsListPage extends StatefulWidget {
  const AgileBoardsListPage({super.key});

  @override
  State<AgileBoardsListPage> createState() => _AgileBoardsListPageState();
}

class _AgileBoardsListPageState extends State<AgileBoardsListPage> {
  late ProjectsListCubit _projectsCubit;

  @override
  void initState() {
    super.initState();
    _projectsCubit = get_it<ProjectsListCubit>()..loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _projectsCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Agile Boards')),
        body: BlocBuilder<ProjectsListCubit, ProjectsListState>(
          builder: (context, state) {
            Widget content;

            if (state.status == .loading) {
              content = Center(
                key: const ValueKey('agile-boards-loading'),
                child: SizedBox(width: 480, child: ShimmerLoading.list(itemCount: 6)),
              );
            } else if (state.status == .failure) {
              content = Center(
                key: const ValueKey('agile-boards-error'),
                child: SelectableText(state.errorMessage ?? ''),
              );
            } else if (state.status == .success) {
              final projects = state.projects;
              if (projects.isEmpty) {
                content = const Center(
                  key: ValueKey('agile-boards-empty'),
                  child: Text('No projects found.'),
                );
              } else {
                content = ListView.builder(
                  key: const ValueKey('agile-boards-list'),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return ListTile(
                      title: Text(project.name),
                      subtitle: Text(project.projectId),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.push(
                          '${AppRouteKeys.agileBoards}/${project.id}',
                          extra: project.name,
                        );
                      },
                    );
                  },
                );
              }
            } else {
              content = const SizedBox.shrink(key: ValueKey('agile-boards-empty'));
            }

            return AnimatedContentSwitcher(child: content);
          },
        ),
      ),
    );
  }
}
