import 'package:flutter/material.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

class MergeUsersDialog extends StatefulWidget {
  final UserEntity user1;
  final UserEntity user2;

  const MergeUsersDialog({
    super.key,
    required this.user1,
    required this.user2,
  });

  @override
  State<MergeUsersDialog> createState() => _MergeUsersDialogState();
}

class _MergeUsersDialogState extends State<MergeUsersDialog> {
  late String _primaryId;

  @override
  void initState() {
    super.initState();
    _primaryId = widget.user1.id;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final primary = _primaryId == widget.user1.id ? widget.user1 : widget.user2;
    final secondary = _primaryId == widget.user1.id ? widget.user2 : widget.user1;
    final mergedGroups = {...widget.user1.groups, ...widget.user2.groups}.toList();
    final mergedProjects = {...widget.user1.projects, ...widget.user2.projects}.toList();

    return AlertDialog(
      title: const Text('Merge Users'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose primary account (will be kept):',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildUserRadio(widget.user1, 'Primary'),
              _buildUserRadio(widget.user2, 'Primary'),
              const Divider(height: 24),
              Text('Merge Preview:',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Name: ${primary.fullName}'),
              Text('Email: ${primary.email}'),
              Text('Groups: ${mergedGroups.length} (${mergedGroups.take(3).join(', ')}${mergedGroups.length > 3 ? '...' : ''})'),
              Text('Projects: ${mergedProjects.length} (${mergedProjects.take(3).join(', ')}${mergedProjects.length > 3 ? '...' : ''})'),
              const SizedBox(height: 8),
              Text('Will delete: ${secondary.fullName} (${secondary.email})',
                  style: textTheme.bodySmall?.copyWith(color: colors.error)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_primaryId),
          style: FilledButton.styleFrom(backgroundColor: colors.error),
          child: const Text('Merge'),
        ),
      ],
    );
  }

  Widget _buildUserRadio(UserEntity user, String label) {
    return RadioListTile<String>(
      title: Text('${user.fullName} (${user.email})'),
      subtitle: Text(user.id),
      value: user.id,
      groupValue: _primaryId,
      onChanged: (value) => setState(() => _primaryId = value!),
    );
  }
}
