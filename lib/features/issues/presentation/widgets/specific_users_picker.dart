import 'package:flutter/material.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import '../../domain/entities/project_member.dart';

class SpecificUsersPicker extends StatefulWidget {
  final List<ProjectMember> members;
  final List<GroupEntity> groups;
  final List<String> initialSelectedIds;
  final List<String> initialSelectedGroupIds;
  final Function(List<String>, List<String>) onSelectionChanged;

  const SpecificUsersPicker({
    super.key,
    required this.members,
    required this.groups,
    required this.initialSelectedIds,
    required this.initialSelectedGroupIds,
    required this.onSelectionChanged,
  });

  static void show(
    BuildContext context, {
    required List<ProjectMember> members,
    required List<GroupEntity> groups,
    required List<String> initialSelectedIds,
    required List<String> initialSelectedGroupIds,
    required Function(List<String>, List<String>) onSelectionChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => SpecificUsersPicker(
        members: members,
        groups: groups,
        initialSelectedIds: initialSelectedIds,
        initialSelectedGroupIds: initialSelectedGroupIds,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }

  @override
  State<SpecificUsersPicker> createState() => _SpecificUsersPickerState();
}

class _SpecificUsersPickerState extends State<SpecificUsersPicker> {
  late List<String> _selectedIds;
  late List<String> _selectedGroupIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.initialSelectedIds);
    _selectedGroupIds = List.from(widget.initialSelectedGroupIds);
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase();
    final filteredGroups = widget.groups
        .where((g) => g.name.toLowerCase().contains(query))
        .toList();
    final filteredMembers = widget.members
        .where((m) =>
            m.name.toLowerCase().contains(query) ||
            (m.email?.toLowerCase().contains(query) ?? false))
        .toList();

    return AlertDialog(
      title: const Text('Select Users & Groups'),
      content: SizedBox(
        width: 320,
        height: 420,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search users or groups...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _SectionHeader(title: 'Groups linked to this project'),
                  if (filteredGroups.isEmpty)
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
                    ...filteredGroups.map((group) {
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(group.name),
                        subtitle: group.description != null
                            ? Text(group.description!)
                            : null,
                        value: _selectedGroupIds.contains(group.id),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedGroupIds.add(group.id);
                            } else {
                              _selectedGroupIds.remove(group.id);
                            }
                          });
                        },
                      );
                    }),
                  const Divider(),
                  _SectionHeader(title: 'Project members'),
                  if (filteredMembers.isEmpty)
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
                    ...filteredMembers.map((member) {
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(member.name),
                        subtitle: member.email != null
                            ? Text(member.email!)
                            : null,
                        value: _selectedIds.contains(member.id),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedIds.add(member.id);
                            } else {
                              _selectedIds.remove(member.id);
                            }
                          });
                        },
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSelectionChanged(_selectedIds, _selectedGroupIds);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
