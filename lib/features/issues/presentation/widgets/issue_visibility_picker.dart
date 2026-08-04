import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';

class IssueVisibilityPicker extends StatefulWidget {
  final Map<String, List<String>> currentVisibility;
  final Function(Map<String, List<String>>) onVisibilityChanged;

  const IssueVisibilityPicker({
    super.key,
    required this.currentVisibility,
    required this.onVisibilityChanged,
  });

  @override
  State<IssueVisibilityPicker> createState() => _IssueVisibilityPickerState();
}

class _IssueVisibilityPickerState extends State<IssueVisibilityPicker> {
  late Map<String, List<String>> _selectedVisibility;

  @override
  void initState() {
    super.initState();
    _selectedVisibility = {
      'users': List.from(widget.currentVisibility['users']!),
      'groups': List.from(widget.currentVisibility['groups']!),
    };
  }

  void _toggleValue(String value, String key, bool? selected) {
    setState(() {
      if (selected == true && !_selectedVisibility[key]!.contains(value)) {
        _selectedVisibility[key]!.add(value);
      } else {
        _selectedVisibility[key]!.remove(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        final groups = state is GroupsLoaded ? state.groups : <GroupEntity>[];
        final users = <_GroupUserEntry>[];

        for (final group in groups) {
          for (final member in group.members) {
            final user = member.user;
            if (user == null) {
              continue;
            }

            final displayName = user.userName.isNotEmpty
                ? user.userName
                : user.email;
            users.add(
              _GroupUserEntry(
                value: 'user:${user.id}',
                title: displayName,
                subtitle: '${group.name} • ${group.members.length} members',
              ),
            );
          }
        }

        final uniqueUsers = <String, _GroupUserEntry>{};
        for (final user in users) {
          uniqueUsers.putIfAbsent(user.value, () => user);
        }

        return AlertDialog(
          title: const Text('Visibility'),
          content: SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text(
                    'Groups linked to this workspace',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  if (groups.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No groups available',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    ...groups.map((group) {
                      final value = 'group:${group.id}';
                      return CheckboxListTile(
                        controlAffinity: .leading,
                        contentPadding: EdgeInsets.zero,
                        title: Text(group.name),
                        subtitle: Text(
                          '${group.members.length} members • ${group.projects.length} projects',
                        ),
                        value: _selectedVisibility['groups']!.contains(value),
                        onChanged: (selected) =>
                            _toggleValue(value, 'groups', selected),
                      );
                    }),
                  const Divider(),
                  const Text(
                    'Specific users',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  if (uniqueUsers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No users available',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    ...uniqueUsers.values.map((user) {
                      return CheckboxListTile(
                        controlAffinity: .leading,
                        contentPadding: EdgeInsets.zero,
                        title: Text(user.title),
                        subtitle: Text(user.subtitle),
                        value: _selectedVisibility['users']!.contains(
                          user.value,
                        ),
                        onChanged: (selected) =>
                            _toggleValue(user.value, 'users', selected),
                      );
                    }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, _selectedVisibility);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _GroupUserEntry {
  final String value;
  final String title;
  final String subtitle;

  const _GroupUserEntry({
    required this.value,
    required this.title,
    required this.subtitle,
  });
}
