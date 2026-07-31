import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_projects_use_case.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/features/roles/domain/usecases/get_roles.dart';

import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';

class AssignRoleDialog extends StatefulWidget {
  final String groupId;

  const AssignRoleDialog({super.key, required this.groupId});

  static Future<GroupRoleAssignmentEntity?> show(
    BuildContext context,
    String groupId,
  ) {
    return showDialog<GroupRoleAssignmentEntity>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GroupsBloc>(),
        child: AssignRoleDialog(groupId: groupId),
      ),
    );
  }

  @override
  State<AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends State<AssignRoleDialog> {
  final _getRoles = GetIt.I<GetRoles>();
  final _getProjects = GetIt.I<GetProjectsUseCase>();

  List<RoleEntity>? _roles;
  List<ProjectEntity>? _projects;
  bool _isLoading = true;

  String? _selectedRoleName;
  String? _selectedProjectId;
  String? _errorMessage;

  bool _isDuplicateAssignment() {
    final state = context.read<GroupsBloc>().state;
    if (state is! GroupsLoaded) return false;

    final groupIndex = state.groups.indexWhere((g) => g.id == widget.groupId);
    if (groupIndex == -1) return false;
    final group = state.groups[groupIndex];

    final isGlobal = _selectedProjectId == '__global__';
    final projectId = isGlobal ? null : _selectedProjectId;

    return group.roles.any(
      (r) => r.roleName == _selectedRoleName && r.projectId == projectId,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final rolesTask = _getRoles(params: const NoParams());
    final projectsTask = _getProjects(params: const NoParams());

    final rolesResult = await rolesTask;
    final projectsResult = await projectsTask;

    rolesResult.fold(
      (_) => null,
      (roles) {
        projectsResult.fold(
          (_) => null,
          (projects) {
            if (!mounted) return;
            setState(() {
              _roles = roles;
              _projects = projects;
              _isLoading = false;
            });
          },
        );
      },
    );
  }

  void _onConfirm() {
    if (_selectedRoleName == null || _selectedProjectId == null) return;

    if (_isDuplicateAssignment()) {
      setState(() {
        _errorMessage =
            'This role is already assigned to this project for this group';
      });
      return;
    }

    final isGlobal = _selectedProjectId == '__global__';
    final projectId = isGlobal ? null : _selectedProjectId;

    final assignment = GroupRoleAssignmentEntity(
      id: '',
      groupId: widget.groupId,
      roleName: _selectedRoleName!,
      projectId: projectId,
    );

    Navigator.pop(context, assignment);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Card(
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Assign Role',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRoleName,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _roles?.map((role) {
                      return DropdownMenuItem(
                        value: role.name,
                        child: Text(role.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRoleName = value;
                        _errorMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProjectId,
                    decoration: const InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      ...?_projects?.map((project) {
                        return DropdownMenuItem(
                          value: project.id,
                          child: Text(project.name),
                        );
                      }),
                      const DropdownMenuItem(
                        value: '__global__',
                        child: Text('Global'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedProjectId = value;
                        _errorMessage = null;
                      });
                    },
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _selectedRoleName != null &&
                                _selectedProjectId != null
                            ? _onConfirm
                            : null,
                        child: const Text('Confirm'),
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
