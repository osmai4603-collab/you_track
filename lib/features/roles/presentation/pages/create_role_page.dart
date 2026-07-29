import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  final _nameController = TextEditingController();
  final _permissionController = TextEditingController();
  final _permissions = <String>[];

  @override
  void dispose() {
    _nameController.dispose();
    _permissionController.dispose();
    super.dispose();
  }

  void _addPermission() {
    final text = _permissionController.text.trim();
    if (text.isNotEmpty && !_permissions.contains(text)) {
      setState(() => _permissions.add(text));
      _permissionController.clear();
    }
  }

  void _removePermission(String perm) {
    setState(() => _permissions.remove(perm));
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    context.read<RolesBloc>().add(CreateRoleEvent(name: name, permissions: _permissions));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Role'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          FilledButton(
            onPressed: _save,
            child: const Text('Create'),
          ),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Field(
              label: 'Name',
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter role name',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            _Field(
              label: 'Permissions',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _permissionController,
                          decoration: const InputDecoration(
                            hintText: 'Add a permission',
                            isDense: true,
                          ),
                          onSubmitted: (_) => _addPermission(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      IconButton.filled(
                        onPressed: _addPermission,
                        icon: const Icon(Icons.add, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _permissions
                        .map(
                          (perm) => Chip(
                            label: Text(perm, style: const TextStyle(fontSize: 13)),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => _removePermission(perm),
                          ),
                        )
                        .toList(),
                  ),
                  if (_permissions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'No permissions added yet',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;

  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
