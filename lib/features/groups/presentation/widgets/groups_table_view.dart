import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/group_table_row.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';

class GroupsTableView extends StatelessWidget {
  final String? userId;

  const GroupsTableView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state is GroupsLoaded) {
          final userSession = context.watch<UserSession>();
          final currentUserId = userSession.currentUser?.id;
          final canReadAllGroups = userSession.hasPermission(Permission.systemLowLevelAdminRead);

          final displayedGroups = state.groups.where((g) {
            if (userId != null && !g.members.any((m) => m.userId == userId)) {
              return false;
            }
            if (canReadAllGroups) return true;
            if (currentUserId == null) return false;
            return g.members.any((m) => m.userId == currentUserId);
          }).toList();

          if (displayedGroups.isEmpty) {
            final canCreateGroup = userSession.hasPermission(Permission.systemLowLevelAdminWrite);
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
                  if (canCreateGroup) ...[
                    const SizedBox(height: AppSpacing.extraSmall),
                    Text(
                      'Create a new group to get started',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
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
                  itemCount: displayedGroups.length,
                  itemBuilder: (context, index) {
                    final group = displayedGroups[index];
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

        return ShimmerLoading.table();
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
