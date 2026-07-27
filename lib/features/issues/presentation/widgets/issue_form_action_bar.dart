import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_visibility_picker.dart';

class IssueFormActionBar extends StatelessWidget {
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  const IssueFormActionBar({
    super.key,
    this.onSubmit,
    this.onCancel,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueFormCubit, IssueFormState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            children: [
              FilledButton(
                onPressed: state.canSubmit ? (onSubmit ?? () => _submit(context)) : null,
                child: Text(state.isEditing ? 'Update' : 'Create'),
              ),
              const SizedBox(width: 4),
              if (state.isEditing)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  onSelected: (value) {
                    if (value == 'create_and_add') {
                      _submit(context);
                      // TODO: Reset form for new issue
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'create_and_add',
                      child: Text('Create and add another'),
                    ),
                  ],
                ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onCancel ?? () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _showVisibilityPicker(context, state),
                icon: const Icon(Icons.visibility, size: 16),
                label: Text(
                  _visibilityLabel(state.visibility),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Spacer(),
              if (state.isEditing)
                TextButton(
                  onPressed: onDelete ?? () => _confirmDelete(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
            ],
          ),
        );
      },
    );
  }

  String _visibilityLabel(List<String> visibility) {
    if (visibility.contains('team') && visibility.length == 1) {
      return 'Visible to team';
    }
    if (visibility.contains('registered') && visibility.length == 1) {
      return 'Visible to registered users';
    }
    if (visibility.any((v) => v.startsWith('user:'))) {
      final count = visibility.where((v) => v.startsWith('user:')).length;
      return 'Visible to $count user${count > 1 ? 's' : ''}';
    }
    return 'Visible to team';
  }

  void _submit(BuildContext context) {
    context.read<IssueFormCubit>().submit();
  }

  void _showVisibilityPicker(BuildContext context, IssueFormState state) {
    showDialog(
      context: context,
      builder: (context) => IssueVisibilityPicker(
        currentVisibility: state.visibility,
        onVisibilityChanged: (visibility) {
          context.read<IssueFormCubit>().updateVisibility(visibility);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Issue'),
        content: const Text('Are you sure you want to delete this issue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<IssueFormCubit>().delete();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
