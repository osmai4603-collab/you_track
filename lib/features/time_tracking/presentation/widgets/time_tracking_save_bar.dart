import 'package:flutter/material.dart';

class TimeTrackingSaveBar extends StatelessWidget {
  final bool hasChanges;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const TimeTrackingSaveBar({
    super.key,
    required this.hasChanges,
    required this.isSaving,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: hasChanges
              ? () => _showDiscardConfirmation(context)
              : null,
          child: const Text('Discard'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: hasChanges && !isSaving ? onSave : null,
          child: isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  void _showDiscardConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'All unsaved changes will be lost. Are you sure you want to discard?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDiscard();
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
