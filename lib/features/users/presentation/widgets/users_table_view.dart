import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_event.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_state.dart';
import 'package:issues_tracking/features/users/presentation/widgets/user_table_row.dart';

class UsersTableView extends StatelessWidget {
  const UsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoaded) {
          if (state.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'No users found',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    'Invite or create a new user to get started',
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
              _TableHeader(
                colors: colors,
                textTheme: textTheme,
                isAllSelected: state.isAllSelected,
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(height: 1),
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return UserTableRow(
                      user: user,
                      isSelected: state.selectedUserId == user.id,
                      isChecked: state.selectedUserIds.contains(user.id),
                      onTap: () {
                        context
                            .read<UsersBloc>()
                            .add(SelectUser(user.id));
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
  final bool isAllSelected;

  const _TableHeader({
    required this.colors,
    required this.textTheme,
    this.isAllSelected = false,
  });

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
          Checkbox(
            value: isAllSelected,
            onChanged: (_) =>
                context.read<UsersBloc>().add(const ToggleSelectAll()),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 36),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Text('Name'),
                const SizedBox(width: 4),
                Icon(Icons.arrow_upward, size: 14, color: colors.primary),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Row(
              children: [
                const Text('Username'),
                const SizedBox(width: 4),
                Icon(Icons.unfold_more, size: 14, color: colors.onSurfaceVariant),
              ],
            ),
          ),
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  const Text('Registration Date'),
                  const SizedBox(width: 4),
                  Icon(Icons.unfold_more, size: 14, color: colors.onSurfaceVariant),
                ],
              ),
            ),
          SizedBox(
            width: 150,
            child: Text('Groups'),
          ),
          SizedBox(
            width: 150,
            child: Text('Projects'),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
