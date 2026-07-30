import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';
import 'package:issues_tracking/features/roles/presentation/widgets/role_table_row.dart';

class RolesTableView extends StatelessWidget {
  const RolesTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        if (state is RolesLoaded) {
          if (state.roles.isEmpty) {
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

          return Column(
            children: [
              _TableHeader(colors: colors, textTheme: textTheme),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(height: 1),
                  itemCount: state.roles.length,
                  itemBuilder: (context, index) {
                    final role = state.roles[index];
                    return RoleTableRow(
                      role: role,
                      isSelected: state.selectedRoleId == role.name,
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

        return const Center(child: CircularProgressIndicator());
      },
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
