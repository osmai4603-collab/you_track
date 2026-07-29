import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
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
            if (state.status == .loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == .failure) {
              return Center(child: SelectableText(state.errorMessage ?? ''));
            } else if (state.status == .success) {
              final projects = state.projects;
              if (projects.isEmpty) {
                return const Center(child: Text('No projects found.'));
              }
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ListTile(
                    title: Text(project.name),
                    subtitle: Text(project.projectKey),
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
