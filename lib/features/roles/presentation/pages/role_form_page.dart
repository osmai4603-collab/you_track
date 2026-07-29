import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';

class RoleFormPage extends StatefulWidget {
  const RoleFormPage({super.key});

  @override
  State<RoleFormPage> createState() => _RoleFormPageState();
}

class _RoleFormPageState extends State<RoleFormPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
            : state.roles.indexWhere(
                (r) => r.id == state.selectedRoleId,
              );
        if (!isNew && roleIndex == -1) {
          return const SizedBox.shrink();
        }
        final role = isNew ? null : state.roles[roleIndex];
        final roleName = isNew ? '' : role!.name;
        final permissions = isNew ? <String>[] : role!.permissions;

        _nameController.text = roleName;

        return Container(
          width: 500,
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(left: BorderSide(color: colors.outlineVariant)),
          ),
          child: Column(
            children: [
              _Header(roleName: roleName, colors: colors, textTheme: textTheme, isNew: isNew),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Field(
                        label: 'Name',
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(isDense: true),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _Field(
                        label: 'Permissions',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: permissions.map((perm) {
                            final isSelected = permissions.contains(perm);
                            return FilterChip(
                              label: Text(perm),
                              selected: isSelected,
                              onSelected: (_) {},
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
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

  const _Header({
    required this.roleName,
    required this.colors,
    required this.textTheme,
    required this.isNew,
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
          if (!isNew)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, size: 18),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  context.read<RolesBloc>().add(const SelectRole(null));
                }
              },
            ),
          const SizedBox(width: 4),
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
