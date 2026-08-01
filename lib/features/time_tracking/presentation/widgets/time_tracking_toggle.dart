import 'package:flutter/material.dart';

class TimeTrackingToggle extends StatelessWidget {
  final bool enabled;
  final VoidCallback onToggle;

  const TimeTrackingToggle({
    super.key,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Enable Time Tracking'),
      controlAffinity: ListTileControlAffinity.leading,
      subtitle: const Text(
        'Allow team members to track time spent on issues',
      ),
      value: enabled,
      onChanged: (value) {
        if (!value) {
          _showDisableConfirmation(context);
        } else {
          onToggle();
        }
      },
    );
  }

  void _showDisableConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Time Tracking?'),
        content: const Text(
          'Disabling time tracking will hide all time tracking settings. '
          'Existing time entries will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onToggle();
            },
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }
}
