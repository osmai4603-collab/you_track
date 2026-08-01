import 'package:fleather/util.dart';
import 'package:flutter/material.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_value_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/repositories/time_tracking_repository.dart';

class WorkItemAttributeDialog extends StatefulWidget {
  final String projectId;
  final WorkItemAttributeEntity? initial;

  const WorkItemAttributeDialog({
    super.key,
    required this.projectId,
    this.initial,
  });

  @override
  State<WorkItemAttributeDialog> createState() =>
      _WorkItemAttributeDialogState();
}

class _WorkItemAttributeDialogState extends State<WorkItemAttributeDialog> {
  late final TextEditingController _nameController;
  late List<WorkItemAttributeValueEntity> _values;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  static const List<Color> _palette = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _values =
        widget.initial?.values
            .map(
              (v) => WorkItemAttributeValueEntity(
                id: v.id,
                value: v.value,
                color: v.color,
                attributeId: v.attributeId,
                firstLetter: v.firstLetter,
              ),
            )
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addValue() {
    setState(() {
      _values.add(
        WorkItemAttributeValueEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          value: '',
          color: _palette.first.value32Bits,
          attributeId: widget.initial?.id ?? '',
          firstLetter: '',
        ),
      );
    });
  }

  void _removeValue(String id) {
    setState(() {
      _values.removeWhere((v) => v.id == id);
    });
  }

  Future<void> _pickColor(
    BuildContext context,
    WorkItemAttributeValueEntity value, {
    required void Function(Color color) onPicked,
  }) async {
    final picked = await showDialog<Color?>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Choose color'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _palette.map((c) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(c),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (picked != null) {
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: const BoxConstraints(maxWidth: 600, minWidth: 600),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      scrollable: true,
      title: Text(
        widget.initial != null
            ? 'Edit Work Item Attribute'
            : 'Add Work Item Attribute',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Attribute name',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Name is required';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _addValue,
              icon: const Icon(Icons.add),
              label: const Text('Add value'),
            ),
            const SizedBox(height: 12),
            ...List.generate(_values.length, (index) {
              final val = _values[index];
              return _buildValueCard(val, index: index);
            }),
            if (_values.isEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Icon(
                      Icons.edit_note,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Specify the list of values you want people to choose from',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _onSaveButtonPressed,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildValueCard(
    WorkItemAttributeValueEntity val, {
    required int index,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _pickColor(
                context,
                val,
                onPicked: (color) {
                  setState(() {
                    _values[index] = val.copyWith(color: color.value32Bits);
                  });
                },
              ),
              child: CircleAvatar(
                backgroundColor: Color(val.color),
                child: Text(
                  val.firstLetter,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text('value name'),
                  TextFormField(
                    initialValue: val.value,
                    onChanged: (v) {
                      setState(() {
                        _values[index] = val.copyWith(
                          value: v,
                          firstLetter: v.isNotEmpty ? v[0].toUpperCase() : '',
                        );
                      });
                    },
                    validator: (v) {
                      if ((v ?? '').trim().isEmpty) return 'Value is required';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _removeValue(val.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  void _onSaveButtonPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final filtered = _values.where((v) => v.value.trim().isNotEmpty).toList();
    final attribute = WorkItemAttributeEntity(
      id: widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      projectId: widget.projectId,
      values: filtered,
    );

    setState(() {
      _isSaving = true;
    });

    final result = widget.initial == null
        ? await get_it<TimeTrackingRepository>().addWorkItemAttribute(
            attribute: attribute,
          )
        : await get_it<TimeTrackingRepository>().updateWorkItemAttribute(
            attribute: attribute,
          );

    result.fold(
      (failure) {
        if (!mounted) return;

        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText('Failed to save attribute: ${failure.message}'),
          ),
        );
        debugPrint(failure.message);
      },
      (saved) {
        if (!mounted) return;
        Navigator.of(context).pop(saved);
      },
    );
  }
}
