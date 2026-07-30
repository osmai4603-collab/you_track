import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/module_enum.dart';
import 'package:issues_tracking/core/enums/operation_enum.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';

enum _GroupBy { entity, operation }

class RoleFormPage extends StatefulWidget {
  const RoleFormPage({super.key});

  @override
  State<RoleFormPage> createState() => _RoleFormPageState();
}

class _RoleFormPageState extends State<RoleFormPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _permissionSearchController = TextEditingController();
  Set<String> _selectedPermissions = {};
  String? _previousRoleName;
  _GroupBy _groupBy = _GroupBy.entity;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _permissionSearchController.dispose();
    super.dispose();
  }

  void _save() {
    final state = context.read<RolesBloc>().state;
    if (state is! RolesLoaded || state.selectedRoleId == null) return;

    final isNew = state.selectedRoleId == 'new';
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final description = _descriptionController.text.trim();
    final desc = description.isEmpty ? null : description;

    if (isNew) {
      context.read<RolesBloc>().add(
        CreateRoleEvent(
          name: name,
          description: desc,
          permissions: _selectedPermissions.toList(),
        ),
      );
    } else {
      context.read<RolesBloc>().add(
        UpdateRoleEvent(
          name: name,
          description: desc,
          permissions: _selectedPermissions.toList(),
        ),
      );
    }
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

    final textTheme = Theme.of(context).textTheme;
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
            mainAxisAlignment: .spaceBetween,
            children: [
              SizedBox(
                width: 225,
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
    return Material(
      color: Colors.transparent,
      child: CheckboxListTile(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        if (state is! RolesLoaded || state.selectedRoleId == null) {
          return const SizedBox.shrink();
        }

        final isNew = state.selectedRoleId == 'new';
        final roleIndex = isNew
            ? -1
            : state.roles.indexWhere((r) => r.name == state.selectedRoleId);
        if (!isNew && roleIndex == -1) {
          return const SizedBox.shrink();
        }
        final role = isNew ? null : state.roles[roleIndex];
        final roleName = isNew ? '' : role!.name;

        _nameController.text = roleName;
        _descriptionController.text = isNew ? '' : (role?.description ?? '');
        if (_previousRoleName != roleName) {
          _previousRoleName = roleName;
          _selectedPermissions = (isNew || role == null)
              ? {}
              : role.permissions.toSet();
        }

        return Container(
          width: 500,
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(left: BorderSide(color: colors.outlineVariant)),
          ),
          child: Column(
            children: [
              _Header(
                roleName: roleName,
                colors: colors,
                textTheme: textTheme,
                isNew: isNew,
                onSave: _save,
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  children: [
                    _Field(
                      label: 'Name',
                      spacing: 4,
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _Field(
                      label: 'Description',
                      spacing: 4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Optional description',
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _buildPermissionsSection(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String roleName;
  final ColorScheme colors;
  final TextTheme textTheme;
  final bool isNew;
  final VoidCallback onSave;

  const _Header({
    required this.roleName,
    required this.colors,
    required this.textTheme,
    required this.isNew,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primaryContainer,
            child: Icon(
              Icons.shield,
              size: 18,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              isNew ? 'New Role' : roleName,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: onSave,
            icon: const Icon(Icons.save, size: 16),
            label: const Text('Save'),
            style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
          const SizedBox(width: AppSpacing.small),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              context.read<RolesBloc>().add(const SelectRole(null));
            },
            tooltip: 'Close',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
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
