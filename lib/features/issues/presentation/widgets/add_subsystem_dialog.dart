import 'package:flutter/material.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/widgets/avatar_url_chip.dart';
import 'package:issues_tracking/core/widgets/youtrack_state.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_subsystems_use_case.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';

class AddSubsystemDialog extends StatefulWidget {
  final SubsystemEntity? subsystem;
  final String projectId;

  const AddSubsystemDialog({
    super.key,
    this.subsystem,
    required this.projectId,
  });

  static Future<SubsystemEntity?> show(
    BuildContext context, {
    SubsystemEntity? subsystem,
    required String projectId,
  }) {
    return showDialog<SubsystemEntity>(
      context: context,
      builder: (context) =>
          AddSubsystemDialog(subsystem: subsystem, projectId: projectId),
    );
  }

  @override
  State<AddSubsystemDialog> createState() => _AddSubsystemDialogState();
}

class _AddSubsystemDialogState extends YouTrackState<AddSubsystemDialog> {
  late TextEditingController _nameController;
  int _selectedColorIndex = 0;
  UserEntity? _selectedOwner;
  Color? _selectedColor;
  String? errorMessage;
  bool _isSaving = false;
  List<UserEntity> _availableOwners =
      []; // This should be populated with actual owners in a real scenario.

  final List<Color> _colors = [
    Colors.blue[100]!,
    Colors.blue[200]!,
    Colors.blue[300]!,
    Colors.blue[400]!,
    Colors.blue[500]!,
    Colors.blue[600]!,
    Colors.blue[700]!,
    Colors.green[100]!,
    Colors.green[200]!,
    Colors.green[300]!,
    Colors.green[400]!,
    Colors.green[500]!,
    Colors.green[600]!,
    Colors.green[700]!,
    Colors.orange[100]!,
    Colors.orange[200]!,
    Colors.orange[300]!,
    Colors.orange[400]!,
    Colors.orange[500]!,
    Colors.orange[600]!,
    Colors.orange[700]!,
    Colors.red[100]!,
    Colors.red[200]!,
    Colors.red[300]!,
    Colors.red[400]!,
    Colors.red[500]!,
    Colors.red[600]!,
    Colors.red[700]!,
    Colors.purple[100]!,
    Colors.purple[200]!,
    Colors.purple[300]!,
    Colors.purple[400]!,
    Colors.purple[500]!,
    Colors.purple[600]!,
    Colors.purple[700]!,
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
    final result = await get_it<GetUsers>()
        .call(); // Replace with actual method to fetch users
    _availableOwners = result.fold((failure) => [], (users) => users);
    setState(() {});
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // limit height to avoid overflow when available space is small
            // subtract viewInsets.bottom so keyboard does not cause overflow
            maxHeight:
                MediaQuery.of(context).size.height * 0.8 -
                MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Subsystem',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel('Name'),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Subsystem name',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Owner'),
                DropdownButtonFormField<UserEntity>(
                  isExpanded: true,
                  initialValue: _selectedOwner,
                  items: _availableOwners
                      .map(
                        (owner) => DropdownMenuItem(
                          value: owner,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AvatarUrlChip(avatarUrl: owner.avatarUrl),
                              const SizedBox(width: 12),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [],
                                ),
                              ),
                              Text(owner.username),
                              const SizedBox(width: 10),
                              Text(
                                owner.email,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      )
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
                          border: isSelected
                              ? Border.all(color: colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'a',
                            style: TextStyle(
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (errorMessage != null)
                  Container(
                    margin: .only(top: 24),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(8),
                        side: BorderSide(color: colors.error),
                      ),
                      color: colors.error.withValues(alpha: 0.20),
                    ),
                    padding: .all(16),
                    child: SelectableText(
                      errorMessage!,
                      style: textTheme.labelSmall!.copyWith(
                        color: colors.error,
                        fontWeight: .bold,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isSaving ? null : _onSaveButtonPressed,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  void _onSaveButtonPressed() async {
    errorMessage = null;
    final context = this.context;
    if (_nameController.text.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final subsystem = SubsystemEntity.create(
        id: widget.subsystem?.id.isNotEmpty == true ? widget.subsystem!.id : '',
        name: _nameController.text,
        projectId: widget.projectId,
        ownerId: _selectedOwner!.id,
        color: _colors[_selectedColorIndex].toARGB32(),
      );
      final usecase = get_it<AddSubsystemUseCase>();
      final result = await usecase(
        params: AddSubsystemParams(subsystem: subsystem),
      );
      if (context.mounted) {
        Navigator.pop(
          context,
          result.fold((failure) => throw failure.message, (result) => result),
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() => _isSaving = false);
    }
  }
}
