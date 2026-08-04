import 'package:flutter/material.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';


class AddSprintDialog extends StatefulWidget {
  final Sprint? sprint;
  final Function(Sprint) onSave;

  const AddSprintDialog({super.key, this.sprint, required this.onSave});

  static Future<void> show(
    BuildContext context, {
    Sprint? sprint,
    required Function(Sprint) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddSprintDialog(sprint: sprint, onSave: onSave),
    );
  }

  @override
  State<AddSprintDialog> createState() => _AddSprintDialogState();
}

class _AddSprintDialogState extends State<AddSprintDialog> {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _releaseDate;
  bool _isReleased = false;
  int _selectedColorIndex = 0;

  final List<Color> _colors = [
    // 7x5 palette (35 colors)
    // Gray tones
    Colors.grey[200]!, Colors.grey[300]!, Colors.grey[400]!, Colors.grey[500]!, Colors.grey[600]!, Colors.grey[700]!, Colors.grey[800]!,
    // Green tones
    Colors.green[100]!, Colors.green[200]!, Colors.green[300]!, Colors.green[400]!, Colors.green[500]!, Colors.green[600]!, Colors.green[700]!,
    // Blue tones
    Colors.blue[100]!, Colors.blue[200]!, Colors.blue[300]!, Colors.blue[400]!, Colors.blue[500]!, Colors.blue[600]!, Colors.blue[700]!,
    // Pink/Red tones
    Colors.pink[100]!, Colors.pink[200]!, Colors.pink[300]!, Colors.pink[400]!, Colors.pink[500]!, Colors.pink[600]!, Colors.pink[700]!,
    // Orange/Brown tones
    Colors.orange[100]!, Colors.orange[200]!, Colors.orange[300]!, Colors.orange[400]!, Colors.orange[500]!, Colors.brown[400]!, Colors.brown[600]!,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sprint?.name ?? '');
    _descriptionController = TextEditingController(text: widget.sprint?.description ?? '');
    _startDate = widget.sprint?.startDate;
    _releaseDate = widget.sprint?.releaseDate;
    _isReleased = widget.sprint?.isReleased ?? false;
    
    if (widget.sprint != null) {
      _selectedColorIndex = _colors.indexWhere((c) => c.toARGB32() == widget.sprint!.color);
      if (_selectedColorIndex == -1) _selectedColorIndex = 0;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _releaseDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _releaseDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add value', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Flexible(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Name'),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Sprint name',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Start date'),
                                _buildDatePicker(
                                  _startDate == null ? 'Set a date' : _startDate!.toLocal().toString().split(' ')[0],
                                  () => _selectDate(context, true),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Release date'),
                                _buildDatePicker(
                                  _releaseDate == null ? 'Set a date' : _releaseDate!.toLocal().toString().split(' ')[0],
                                  () => _selectDate(context, false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isReleased,
                            onChanged: (val) => setState(() => _isReleased = val ?? false),
                          ),
                          const Text('Released'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Description'),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Optional description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Color Selection'),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _colors.length,
                        itemBuilder: (context, index) {
                          final color = _colors[index];
                          final isSelected = _selectedColorIndex == index;
                          return InkWell(
                            onTap: () => setState(() => _selectedColorIndex = index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                                border: isSelected ? Border.all(color: colorScheme.primary, width: 2) : null,
                              ),
                              child: Center(
                                child: Text(
                                  'a',
                                  style: TextStyle(
                                    color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
                    final sprint = Sprint(
                      id: widget.sprint?.id.isNotEmpty == true 
                          ? widget.sprint!.id 
                          : DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      startDate: _startDate,
                      releaseDate: _releaseDate,
                      isReleased: _isReleased,
                      description: _descriptionController.text,
                      color: _colors[_selectedColorIndex].toARGB32(),
                    );
                    widget.onSave(sprint);
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }

  Widget _buildDatePicker(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
            Expanded(child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14))),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
