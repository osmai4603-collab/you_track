import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';

class AddProjectDialog extends StatefulWidget {
  final String groupId;
  final List<GroupProjectEntity> existingProjects;

  const AddProjectDialog({
    super.key,
    required this.groupId,
    required this.existingProjects,
  });

  static Future<void> show(
    BuildContext context,
    String groupId,
    List<GroupProjectEntity> existingProjects,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GroupsBloc>(),
        child: AddProjectDialog(
          groupId: groupId,
          existingProjects: existingProjects,
        ),
      ),
    );
  }

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _getProjects = GetIt.I<GetProjectsUseCase>();

  List<ProjectEntity>? _projects;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final _selectedProjectIds = <String>{};
  Set<String> _existingProjectIds = {};

  @override
  void initState() {
    super.initState();
    _existingProjectIds =
        widget.existingProjects.map((p) => p.projectId).toSet();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final result = await _getProjects(params: const NoParams());
    result.fold(
      (_) {
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
      (projects) {
        if (!mounted) return;
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
      },
    );
  }

  void _onAddProjects() {
    if (_selectedProjectIds.isEmpty) return;

    setState(() => _isSubmitting = true);

    if (!mounted) return;
    context.read<GroupsBloc>().add(
          AddGroupProjectsEvent(
            groupId: widget.groupId,
            projectIds: _selectedProjectIds.toList(),
          ),
        );

    Navigator.pop(context, _selectedProjectIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Card(
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Add projects',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 16,
                        headingRowHeight: 40,
                        dataRowMinHeight: 40,
                        dataRowMaxHeight: 48,
                        columns: [
                          DataColumn(
                            label: Text(
                              '',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Project',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Key',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        rows: _projects?.map((project) {
                          final isExisting =
                              _existingProjectIds.contains(project.id);
                          final isSelected =
                              _selectedProjectIds.contains(project.id);
                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: isExisting
                                ? null
                                : (selected) {
                                    if (selected == true) {
                                      setState(() =>
                                          _selectedProjectIds.add(project.id));
                                    } else {
                                      setState(() =>
                                          _selectedProjectIds.remove(project.id));
                                    }
                                  },
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: isSelected || isExisting,
                                  onChanged: isExisting
                                      ? null
                                      : (value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedProjectIds
                                                  .add(project.id);
                                            } else {
                                              _selectedProjectIds
                                                  .remove(project.id);
                                            }
                                          });
                                        },
                                ),
                              ),
                              DataCell(
                                Text(
                                  project.name,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: isExisting
                                        ? colors.onSurfaceVariant
                                        : colors.onSurface,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  project.projectId,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: isExisting
                                        ? colors.onSurfaceVariant
                                        : colors.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList() ??
                            [],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed:
                            _selectedProjectIds.isNotEmpty && !_isSubmitting
                                ? _onAddProjects
                                : null,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Add projects'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
