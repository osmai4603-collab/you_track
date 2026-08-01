import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';
import 'package:issues_tracking/features/roles/presentation/widgets/role_table_row.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';

class RolesTableView extends StatelessWidget {
  final String? userId;

  const RolesTableView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        if (state is RolesLoaded) {
          // If no userId provided, show all roles as before
          if (userId == null) {
            if (state.roles.isEmpty) return _emptyState(colors, textTheme);
            return _buildRolesList(state.roles, state.selectedRoleId, colors, textTheme, context);
          }

          // When userId is provided, derive assigned roles from groups
          return BlocBuilder<GroupsBloc, GroupsState>(builder: (context, gState) {
            if (gState is! GroupsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final assignedRoleNames = <String>{};
            for (final g in gState.groups) {
              final isMember = g.members.any((m) => m.userId == userId);
              if (isMember) {
                for (final r in g.roles) {
                  assignedRoleNames.add(r.roleName);
                }
              }
            }

            final displayedRoles = state.roles.where((r) => assignedRoleNames.contains(r.name)).toList();
            if (displayedRoles.isEmpty) return _emptyState(colors, textTheme);

            return _buildRolesList(displayedRoles, state.selectedRoleId, colors, textTheme, context);
          });
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _emptyState(ColorScheme colors, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 48,
            color: colors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'No roles found',
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            'Create a new role to get started',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList(List roles, String? selectedRoleId, ColorScheme colors, TextTheme textTheme, BuildContext context) {
    return Column(
      children: [
        _TableHeader(colors: colors, textTheme: textTheme),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return RoleTableRow(
                role: role,
                isSelected: selectedRoleId == role.name,
                onTap: () {
                  context.read<RolesBloc>().add(SelectRole(role.name));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _TableHeader({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.small,
      ),
      color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          const SizedBox(width: 40),
          const SizedBox(width: AppSpacing.small),
          SizedBox(
            width: 200,
            child: Text('Name', style: textTheme.labelMedium),
          ),
          SizedBox(
            width: 200,
            child: Text('Permissions', style: textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}
