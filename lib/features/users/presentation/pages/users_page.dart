import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/usecases/get_group_members.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_event.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_state.dart';
import 'package:issues_tracking/features/users/presentation/pages/new_user_dialog.dart';
import 'package:issues_tracking/features/users/presentation/widgets/confirm_action_dialog.dart';
import 'package:issues_tracking/features/users/presentation/widgets/group_selection_dialog.dart';
import 'package:issues_tracking/features/users/presentation/widgets/merge_users_dialog.dart';
import 'package:issues_tracking/features/users/presentation/widgets/users_table_view.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(const LoadUsers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersError) {
          return Center(child: SelectableText(state.message));
        }

        final loaded = state is UsersLoaded ? state : null;

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSearchField(colors),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildDropdownButton(
                      'Add to group',
                      colors,
                      enabled: loaded != null && loaded.hasSelection,
                      onTap: loaded != null ? () => _onAddToGroup(context, loaded) : null,
                    ),
                    const SizedBox(width: 8),
                    _buildDropdownButton(
                      'Remove from group',
                      colors,
                      enabled: loaded != null && loaded.hasSelection,
                      onTap: loaded != null ? () => _onRemoveFromGroup(context, loaded) : null,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Ban',
                      colors,
                      enabled: loaded != null && loaded.hasSelection,
                      onTap: loaded != null ? () => _onBan(context, loaded) : null,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Merge',
                      colors,
                      enabled: loaded != null && loaded.selectedUserIds.length == 2,
                      onTap: loaded != null ? () => _onMerge(context, loaded) : null,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Delete',
                      colors,
                      enabled: loaded != null && loaded.hasSelection,
                      onTap: loaded != null ? () => _onDelete(context, loaded) : null,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Manage custom attributes',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => _showNewUserDialog(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('New User'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(child: UsersTableView()),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () {},
            backgroundColor: colors.primary,
            child: const Icon(Icons.help_outline, color: Colors.white),
          ),
        );
      },
    );
  }

  void _onDelete(BuildContext context, UsersLoaded state) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmActionDialog(
        title: 'Delete Users',
        message:
            'Are you sure you want to delete ${state.selectedUserIds.length} user(s)? This action cannot be undone.',
        confirmLabel: 'Delete',
        confirmColor: Theme.of(context).colorScheme.error,
        onConfirm: () {
          context
              .read<UsersBloc>()
              .add(DeleteUsersEvent(state.selectedUserIds.toList()));
        },
      ),
    );
  }

  void _onBan(BuildContext context, UsersLoaded state) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmActionDialog(
        title: 'Ban Users',
        message:
            'Are you sure you want to ban ${state.selectedUserIds.length} user(s)?',
        confirmLabel: 'Ban',
        confirmColor: Theme.of(context).colorScheme.error,
        onConfirm: () {
          context
              .read<UsersBloc>()
              .add(BanUsersEvent(userIds: state.selectedUserIds.toList(), ban: true));
        },
      ),
    );
  }

  void _onAddToGroup(BuildContext context, UsersLoaded state) async {
    final bloc = context.read<UsersBloc>();
    final result = await bloc.getGroups(params: const NoParams());
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (groups) async {
        final groupId = await showDialog<String>(
          context: context,
          builder: (ctx) => GroupSelectionDialog(groups: groups),
        );
        if (groupId == null) return;

        final membersResult =
            await bloc.getGroupMembers(params: GetGroupMembersParams(groupId: groupId));
        membersResult.fold(
          (failure) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message)),
            );
          },
          (members) {
            if (!context.mounted) return;
            final existingIds = members.map((m) => m.userId).toSet();
            final userIdsToAdd =
                state.selectedUserIds.where((id) => !existingIds.contains(id)).toList();
            final skipped = state.selectedUserIds.length - userIdsToAdd.length;

            if (userIdsToAdd.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All selected users are already members of this group'),
                ),
              );
              return;
            }

            if (skipped > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$skipped user(s) skipped because they are already in this group',
                  ),
                ),
              );
            }

            bloc.add(AddUsersToGroupEvent(
              userIds: userIdsToAdd,
              groupId: groupId,
            ));
          },
        );
      },
    );
  }

  void _onRemoveFromGroup(BuildContext context, UsersLoaded state) async {
    final getGroupsUseCase = context.read<UsersBloc>().getGroups;
    final result = await getGroupsUseCase(params: const NoParams());
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (groups) async {
        final groupId = await showDialog<String>(
          context: context,
          builder: (ctx) => GroupSelectionDialog(groups: groups),
        );
        if (groupId != null) {
          if (!context.mounted) return;
          context.read<UsersBloc>().add(
                RemoveUsersFromGroupEvent(
                  userIds: state.selectedUserIds.toList(),
                  groupId: groupId,
                ),
              );
        }
      },
    );
  }

  void _onMerge(BuildContext context, UsersLoaded state) async {
    final ids = state.selectedUserIds.toList();
    if (ids.length != 2) return;
    final user1 = state.users.firstWhere((u) => u.id == ids[0]);
    final user2 = state.users.firstWhere((u) => u.id == ids[1]);
    final primaryId = await showDialog<String>(
      context: context,
      builder: (ctx) => MergeUsersDialog(user1: user1, user2: user2),
    );
    if (primaryId != null) {
      if (!context.mounted) return;
      final secondaryId = ids.firstWhere((id) => id != primaryId);
      context.read<UsersBloc>().add(
            MergeUsersEvent(
              primaryUserId: primaryId,
              secondaryUserId: secondaryId,
            ),
          );
    }
  }

  Widget _buildSearchField(ColorScheme colors) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.add, size: 18, color: colors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for text or add a filter',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, size: 18, color: colors.onSurfaceVariant),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(
    String label,
    ColorScheme colors, {
    bool enabled = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? colors.outlineVariant : colors.outlineVariant.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: enabled ? colors.onSurface : colors.onSurface.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: enabled
                  ? colors.onSurfaceVariant
                  : colors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    ColorScheme colors, {
    bool enabled = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? colors.outlineVariant : colors.outlineVariant.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: enabled ? colors.onSurface : colors.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  void _showNewUserDialog(BuildContext context) {
    final usersBloc = context.read<UsersBloc>();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) =>
          BlocProvider.value(value: usersBloc, child: const NewUserDialog()),
    );
  }
}
