import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/services/supabase_storage_service.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_event.dart';

class EditUserDialog extends StatefulWidget {
  final UserEntity user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  String? _avatarUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _avatarUrl = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar() async {
    try {
      final result = await FilePicker.pickFiles(type: FileType.image);
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      setState(() => _isUploading = true);

      final fileName =
          'avatars/${widget.user.id}_${DateTime.now().millisecondsSinceEpoch}';
      final storageService = get_it<SupabaseStorageService>();

      await for (final state in storageService.uploadFile(
        path: fileName,
        file: file,
      )) {
        if (state.status == UploadStatus.success) {
          if (!mounted) return;
          setState(() {
            _avatarUrl = state.downloadUrl;
            _isUploading = false;
          });
          break;
        } else if (state.status == UploadStatus.failure) {
          setState(() => _isUploading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Upload failed')),
            );
          }
          break;
        }
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.user.copyWith(
      displayName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      avatarUrl: _avatarUrl,
    );

    context.read<UsersBloc>().add(EditUserEvent(updated));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final initials = widget.user.initials.isNotEmpty
        ? widget.user.initials
        : widget.user.userKey;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 480,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit User',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildField('Full name', _fullNameController, colors, textTheme,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 14),
                _buildField('Username', _usernameController, colors, textTheme,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 14),
                _buildField('Email', _emailController, colors, textTheme,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 14),
                _buildAvatarSection(colors, textTheme, initials),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isUploading ? null : _save,
                      child: const Text('Save'),
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

  Widget _buildAvatarSection(
    ColorScheme colors,
    TextTheme textTheme,
    String initials,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avatar',
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colors.primaryContainer,
              foregroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty
                  ? NetworkImage(_avatarUrl!)
                  : null,
              child: Text(
                initials,
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (_isUploading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              OutlinedButton.icon(
                onPressed: _pickAndUploadAvatar,
                icon: const Icon(Icons.upload_file, size: 16),
                label: const Text('Upload avatar'),
              ),
            if (_avatarUrl != null && !_isUploading) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Remove avatar',
                onPressed: () => setState(() => _avatarUrl = null),
                icon: const Icon(Icons.delete_outline, size: 18),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    ColorScheme colors,
    TextTheme textTheme, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: const InputDecoration(hintText: ''),
        ),
      ],
    );
  }
}