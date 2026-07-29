import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/group_table_row.dart';

class GroupsTableView extends StatelessWidget {
  const GroupsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state is GroupsLoaded) {
          if (state.groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_off,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'No groups found',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    'Create a new group to get started',
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
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    final group = state.groups[index];
                    return GroupTableRow(
                      group: group,
                      isSelected: state.selectedGroupId == group.id,
                      onTap: () {
                        context.read<GroupsBloc>().add(SelectGroup(group.id));
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
          Expanded(
            flex: 2,
            child: Text('Name', style: textTheme.labelMedium),
          ),
          SizedBox(width: 150, child: Text('Type', style: textTheme.labelMedium)),
          SizedBox(width: 100, child: Text('Auto-join', style: textTheme.labelMedium)),
          SizedBox(width: 120, child: Text('2FA', style: textTheme.labelMedium)),
        ],
      ),
    );
  }
}
