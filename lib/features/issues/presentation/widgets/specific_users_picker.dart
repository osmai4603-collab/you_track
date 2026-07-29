import 'package:flutter/material.dart';
import '../../domain/entities/project_member.dart';

class SpecificUsersPicker extends StatefulWidget {
  final List<ProjectMember> members;
  final List<String> initialSelectedIds;
  final Function(List<String>) onSelectionChanged;

  const SpecificUsersPicker({
    super.key,
    required this.members,
    required this.initialSelectedIds,
    required this.onSelectionChanged,
  });

  static void show(
    BuildContext context, {
    required List<ProjectMember> members,
    required List<String> initialSelectedIds,
    required Function(List<String>) onSelectionChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => SpecificUsersPicker(
        members: members,
        initialSelectedIds: initialSelectedIds,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }

  @override
  State<SpecificUsersPicker> createState() => _SpecificUsersPickerState();
}

class _SpecificUsersPickerState extends State<SpecificUsersPicker> {
  late List<String> _selectedIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.initialSelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = widget.members
        .where((m) =>
            m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (m.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
        .toList();

    return AlertDialog(
      title: const Text('Select Users'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  final isSelected = _selectedIds.contains(member.id);

                  return CheckboxListTile(
                    title: Text(member.name),
                    subtitle: member.email != null ? Text(member.email!) : null,
                    value: isSelected,
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
                },
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
            widget.onSelectionChanged(_selectedIds);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
