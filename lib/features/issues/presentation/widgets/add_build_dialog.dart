import 'package:flutter/material.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';

class AddBuildDialog extends StatefulWidget {
  final Build? build;
  final Function(Build) onSave;

  const AddBuildDialog({super.key, this.build, required this.onSave});

  static Future<void> show(
    BuildContext context, {
    Build? build,
    required Function(Build) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddBuildDialog(build: build, onSave: onSave),
    );
  }

  @override
  State<AddBuildDialog> createState() => _AddBuildDialogState();
}

class _AddBuildDialogState extends State<AddBuildDialog> {
  late TextEditingController _nameController;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.build?.name ?? '');
    _date = widget.build?.date;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add value', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Name', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Build name',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Date', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _date == null ? 'Set a date' : _date!.toLocal().toString().split(' ')[0],
                        style: TextStyle(color: _date == null ? Colors.grey : Colors.black87, fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) return;
                    final build = Build(
                      id: widget.build != null && widget.build!.id.isNotEmpty
                          ? widget.build!.id
                          : DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      date: _date,
                    );
                    widget.onSave(build);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
