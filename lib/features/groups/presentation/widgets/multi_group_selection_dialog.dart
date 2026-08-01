import 'package:flutter/material.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

class MultiGroupSelectionDialog extends StatefulWidget {
  final List<GroupEntity> groups;
  final Set<String> selectedIds;

  const MultiGroupSelectionDialog({
    super.key,
    required this.groups,
    required this.selectedIds,
  });

  @override
  State<MultiGroupSelectionDialog> createState() =>
      _MultiGroupSelectionDialogState();
}

class _MultiGroupSelectionDialogState extends State<MultiGroupSelectionDialog> {
  late final Set<String> _selectedIds = {...widget.selectedIds};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select groups'),
      content: SizedBox(
        width: 360,
        height: 400,
        child: widget.groups.isEmpty
            ? const Center(child: Text('No groups available'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.groups.length,
                itemBuilder: (context, index) {
                  final group = widget.groups[index];
                  return CheckboxListTile(
                    title: Text(group.name),
                    value: _selectedIds.contains(group.id),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedIds.add(group.id);
                        } else {
                          _selectedIds.remove(group.id);
                        }
                      });
                    },
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
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
          onPressed: () => Navigator.of(context).pop(_selectedIds),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
