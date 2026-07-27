import 'package:flutter/material.dart';
import 'package:issues_tracking/core/enums/time_tracking_field_type_enum.dart';

class CustomAttributeFormDialog extends StatefulWidget {
  final String? initialName;
  final TimeTrackingFieldType? initialFieldType;
  final bool initialIsRequired;
  final List<String>? initialOptions;
  final void Function(String name, String fieldType, bool isRequired, List<String>? options) onSave;

  const CustomAttributeFormDialog({
    super.key,
    this.initialName,
    this.initialFieldType,
    this.initialIsRequired = false,
    this.initialOptions,
    required this.onSave,
  });

  @override
  State<CustomAttributeFormDialog> createState() => _CustomAttributeFormDialogState();
}

class _CustomAttributeFormDialogState extends State<CustomAttributeFormDialog> {
  late final TextEditingController _nameController;
  late TimeTrackingFieldType _selectedFieldType;
  late bool _isRequired;
  late List<String> _options;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedFieldType = widget.initialFieldType ?? TimeTrackingFieldType.text;
    _isRequired = widget.initialIsRequired;
    _options = List<String>.from(widget.initialOptions ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName != null ? 'Edit Custom Attribute' : 'Add Custom Attribute'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TimeTrackingFieldType>(
                initialValue: _selectedFieldType,
                decoration: const InputDecoration(
                  labelText: 'Field Type',
                  border: OutlineInputBorder(),
                ),
                items: TimeTrackingFieldType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFieldType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Required'),
                contentPadding: EdgeInsets.zero,
                value: _isRequired,
                onChanged: (value) {
                  setState(() {
                    _isRequired = value;
                  });
                },
              ),
              if (_selectedFieldType == TimeTrackingFieldType.dropdown) ...[
                const SizedBox(height: 16),
                const Text('Options', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ..._options.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: entry.value,
                            decoration: InputDecoration(
                              labelText: 'Option ${entry.key + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _options[entry.key] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () {
                            setState(() {
                              _options.removeAt(entry.key);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _options.add('');
                    });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Option'),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final filteredOptions = _selectedFieldType == TimeTrackingFieldType.dropdown
                  ? _options.where((o) => o.trim().isNotEmpty).toList()
                  : null;
              widget.onSave(
                _nameController.text.trim(),
                _selectedFieldType.value,
                _isRequired,
                filteredOptions,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
