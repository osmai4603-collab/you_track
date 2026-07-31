import 'package:flutter/material.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

class GroupSelectionDialog extends StatefulWidget {
  final List<GroupEntity> groups;

  const GroupSelectionDialog({super.key, required this.groups});

  @override
  State<GroupSelectionDialog> createState() => _GroupSelectionDialogState();
}

class _GroupSelectionDialogState extends State<GroupSelectionDialog> {
  String? _selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Group'),
      content: SizedBox(
        width: 320,
        child: widget.groups.isEmpty
            ? const Text('No groups available')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.groups.length,
                itemBuilder: (context, index) {
                  final group = widget.groups[index];
                  return RadioListTile<String>(
                    title: Text(group.name),
                    value: group.id,
                    groupValue: _selectedGroupId,
                    onChanged: (value) {
                      setState(() => _selectedGroupId = value);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedGroupId != null
              ? () => Navigator.of(context).pop(_selectedGroupId)
              : null,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
