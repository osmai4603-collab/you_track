import 'package:flutter/material.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/widgets/avatar_url_chip.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';

class AddSubsystemDialog extends StatefulWidget {
  final SubsystemEntity? subsystem;
  final Function(SubsystemEntity) onSave;

  const AddSubsystemDialog({super.key, this.subsystem, required this.onSave});

  static Future<void> show(
    BuildContext context, {
    SubsystemEntity? subsystem,
    required Function(SubsystemEntity) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddSubsystemDialog(subsystem: subsystem, onSave: onSave),
    );
  }

  @override
  State<AddSubsystemDialog> createState() => _AddSubsystemDialogState();
}

class _AddSubsystemDialogState extends State<AddSubsystemDialog> {
  late TextEditingController _nameController;
  int _selectedColorIndex = 0;
  UserEntity? _selectedOwner;
  Color? _selectedColor;
  List<UserEntity> _availableOwners = []; // This should be populated with actual owners in a real scenario.


  final List<Color> _colors = [
    Colors.blue[100]!, Colors.blue[200]!, Colors.blue[300]!, Colors.blue[400]!, Colors.blue[500]!, Colors.blue[600]!, Colors.blue[700]!,
    Colors.green[100]!, Colors.green[200]!, Colors.green[300]!, Colors.green[400]!, Colors.green[500]!, Colors.green[600]!, Colors.green[700]!,
    Colors.orange[100]!, Colors.orange[200]!, Colors.orange[300]!, Colors.orange[400]!, Colors.orange[500]!, Colors.orange[600]!, Colors.orange[700]!,
    Colors.red[100]!, Colors.red[200]!, Colors.red[300]!, Colors.red[400]!, Colors.red[500]!, Colors.red[600]!, Colors.red[700]!,
    Colors.purple[100]!, Colors.purple[200]!, Colors.purple[300]!, Colors.purple[400]!, Colors.purple[500]!, Colors.purple[600]!, Colors.purple[700]!,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subsystem?.name ?? '');
    _selectedColorIndex = _getColorIndex(widget.subsystem?.color);
    _init();
  }

  void _init() async {
    // In a real scenario, you would fetch the available owners from a repository or service.
    // For this example, we'll just create some dummy users.
    final result = await get_it<GetUsers>().execute(); // Replace with actual method to fetch users
    _availableOwners = result.fold((failure) => [], (users) => users);
    setState(() { });
    }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int _getColorIndex(int? color) {
    if (color == null) return 0;
    for (int i = 0; i < _colors.length; i++) {
      if (_colors[i].toARGB32() == color) {
        return i;
      }
    }
    return 0;
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Subsystem', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildLabel('Name'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Subsystem name',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Owner'),
              DropdownButtonFormField<UserEntity>(
                initialValue: _selectedOwner,
                items: _availableOwners.map((owner) => DropdownMenuItem(
                      value: owner,
                      child: ListTile(
                        dense: true,
                        title: Text(owner.username),
                        subtitle: Text(owner.email),
                        leading: AvatarUrlChip(
                          avatarUrl: owner.avatarUrl,
                        ),
                      ),
                    ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedOwner = value);
                  }
                },
              ),
              const SizedBox(height: 16),
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
                      final subsystem = SubsystemEntity(
                        id: widget.subsystem?.id.isNotEmpty == true
                            ? widget.subsystem!.id
                            : DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        projectId: 'DEM',
                        ownerId: 'admin',
                        color: _colors[_selectedColorIndex].toARGB32(),
                        firstLetter: _nameController.text.isNotEmpty
                            ? _nameController.text[0].toUpperCase()
                            : 'S',
                      );
                      widget.onSave(subsystem);
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }
}
