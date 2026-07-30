import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/module_enum.dart';
import 'package:issues_tracking/core/enums/operation_enum.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/widgets/youtrack_state.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

enum _GroupBy { entity, operation }

class _CreateRolePageState extends YouTrackState<CreateRolePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _permissionSearchController = TextEditingController();
  final _selectedPermissions = <String>{};
  _GroupBy _groupBy = _GroupBy.entity;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final description = _descriptionController.text.trim();
    final desc = description.isEmpty ? null : description;
    context.read<RolesBloc>().add(
      CreateRoleEvent(
        name: name,
        description: desc,
        permissions: _selectedPermissions.toList(),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Role'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          FilledButton(onPressed: _save, child: const Text('Create')),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
      body: Align(
        child: SizedBox(
          width: 600,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            children: [
              _Field(
                label: 'Name',
                spacing: 4,
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
                spacing: 4,
                label: 'Description',
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Optional description',
                    isDense: true,
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              _buildPermissionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    final filterQuery = _permissionSearchController.text.trim().toLowerCase();
    final filtered = filterQuery.isEmpty
        ? Permission.values
        : Permission.values.where(
            (p) =>
                p.name.toLowerCase().contains(filterQuery) ||
                p.module.name.toLowerCase().contains(filterQuery) ||
                p.operation.name.toLowerCase().contains(filterQuery),
          );

    final colors = Theme.of(context).colorScheme;

    Widget buildGroupedList() {
      if (_groupBy == _GroupBy.entity) {
        final grouped = <Module, List<Permission>>{};
        for (final p in filtered) {
          grouped.putIfAbsent(p.module, () => []).add(p);
        }
        return Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: grouped.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      entry.key.name.toUpperCase(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...entry.value.map(
                    (permission) => _permissionTile(permission),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      } else {
        final grouped = <Operation, List<Permission>>{};
        for (final p in filtered) {
          grouped.putIfAbsent(p.operation, () => []).add(p);
        }
        final operationOrder = Operation.values;
        return Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: operationOrder.where((op) => grouped.containsKey(op)).map((
            op,
          ) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      op.name[0].toUpperCase() + op.name.substring(1),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...grouped[op]!.map(
                    (permission) => _permissionTile(permission),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }
    }

    return _Field(
      label: 'Permissions ${_selectedPermissions.length}',
      spacing: 8,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 250,
                height: 32,
                child: TextField(
                  controller: _permissionSearchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(AppIcons.search),
                    hintText: 'Filter permissions',
                    contentPadding: .all(0),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const Spacer(),
              SegmentedButton<_GroupBy>(
                segments: const [
                  ButtonSegment(value: _GroupBy.entity, label: Text('Entity')),
                  ButtonSegment(
                    value: _GroupBy.operation,
                    label: Text('Operation'),
                  ),
                ],
                selected: {_groupBy},
                onSelectionChanged: (v) => setState(() => _groupBy = v.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          buildGroupedList(),
        ],
      ),
    );
  }

  Widget _permissionTile(Permission permission) {
    final isChecked = _selectedPermissions.contains(permission.name);
    return CheckboxListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(permission.name, style: const TextStyle(fontSize: 13)),
      value: isChecked,
      onChanged: (checked) {
        setState(() {
          if (checked == true) {
            _selectedPermissions.add(permission.name);
          } else {
            _selectedPermissions.remove(permission.name);
          }
        });
      },
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final double spacing;
  final Widget child;

  const _Field({required this.label, required this.child, this.spacing = 32});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        child,
      ],
    );
  }
}
