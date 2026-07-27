import 'package:flutter/material.dart';

class IssueVisibilityPicker extends StatefulWidget {
  final List<String> currentVisibility;
  final Function(List<String>) onVisibilityChanged;

  const IssueVisibilityPicker({
    super.key,
    required this.currentVisibility,
    required this.onVisibilityChanged,
  });

  @override
  State<IssueVisibilityPicker> createState() => _IssueVisibilityPickerState();
}

class _IssueVisibilityPickerState extends State<IssueVisibilityPicker> {
  late List<String> _selectedVisibility;

  @override
  void initState() {
    super.initState();
    _selectedVisibility = List.from(widget.currentVisibility);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Visibility'),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project team',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('All team members'),
              value: _selectedVisibility.contains('team'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVisibility.add('team');
                  } else {
                    _selectedVisibility.remove('team');
                  }
                });
              },
            ),
            const Divider(),
            const Text(
              'Registered users',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('All registered users'),
              value: _selectedVisibility.contains('registered'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVisibility.add('registered');
                  } else {
                    _selectedVisibility.remove('registered');
                  }
                });
              },
            ),
            const Divider(),
            const Text(
              'Specific users',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            // TODO: Replace with actual user list from project members
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('John Doe'),
              value: _selectedVisibility.contains('user:john-doe'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVisibility.add('user:john-doe');
                  } else {
                    _selectedVisibility.remove('user:john-doe');
                  }
                });
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Jane Smith'),
              value: _selectedVisibility.contains('user:jane-smith'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedVisibility.add('user:jane-smith');
                  } else {
                    _selectedVisibility.remove('user:jane-smith');
                  }
                });
              },
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
            widget.onVisibilityChanged(_selectedVisibility);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
