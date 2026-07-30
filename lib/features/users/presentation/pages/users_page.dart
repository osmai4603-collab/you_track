import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_event.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_state.dart';
import 'package:issues_tracking/features/users/presentation/pages/new_user_dialog.dart';
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
                    _buildDropdownButton('Add to group', colors),
                    const SizedBox(width: 8),
                    _buildDropdownButton('Remove from group', colors),
                    const SizedBox(width: 8),
                    _buildActionButton('Ban', colors),
                    const SizedBox(width: 8),
                    _buildActionButton('Merge', colors),
                    const SizedBox(width: 8),
                    _buildActionButton('Delete', colors),
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

  Widget _buildDropdownButton(String label, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 18, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }

  void _showNewUserDialog(BuildContext context) {
    final usersBloc = context.read<UsersBloc>();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => BlocProvider.value(
        value: usersBloc,
        child: const NewUserDialog(),
      ),
    );
  }
}
