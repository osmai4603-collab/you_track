import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_bloc.dart';
import 'package:issues_tracking/features/users/presentation/bloc/users_event.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({super.key});

  @override
  State<NewUserDialog> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailTextController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _forceChangePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailTextController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _inviteUsers() {
    final text = _emailTextController.text.trim();
    if (text.isEmpty) return;
    final emails = text.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (emails.isEmpty) return;
    context.read<UsersBloc>().add(InviteUsersEvent(emails: emails));
    Navigator.of(context).pop();
  }

  void _createUser() {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    context.read<UsersBloc>().add(CreateUserEvent(
      displayName: name,
      email: email,
      password: password,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: const Color(0xFF222326),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Text(
                'New User',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _tabController.index == 0
                                ? colors.primary
                                : const Color(0xFF2E2E32),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Invite users',
                            style: TextStyle(
                              color: _tabController.index == 0
                                  ? Colors.white
                                  : colors.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _tabController.index == 1
                                ? colors.primary
                                : const Color(0xFF2E2E32),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Create user',
                            style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.white
                                  : colors.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInviteTab(colors, textTheme),
                    _buildCreateTab(colors, textTheme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.onSurfaceVariant,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _tabController.index == 0 ? _inviteUsers : _createUser,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primary,
                    ),
                    child: Text(
                      _tabController.index == 0 ? 'Invite' : 'Create',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteTab(ColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emails',
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailTextController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText:
                'Enter a space-separated list of email addresses',
            hintStyle: TextStyle(color: colors.onSurfaceVariant.withValues(alpha: 0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateTab(ColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField('Full name', _fullNameController, colors, textTheme),
        const SizedBox(height: 14),
        _buildField('Email', _emailController, colors, textTheme),
        const SizedBox(height: 14),
        _buildField('Password', _passwordController, colors, textTheme,
            obscureText: true),
        const SizedBox(height: 14),
        _buildField('Confirm password', _confirmPasswordController, colors,
            textTheme,
            obscureText: true),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _forceChangePassword,
                onChanged: (v) =>
                    setState(() => _forceChangePassword = v ?? true),
                fillColor: WidgetStateProperty.all(colors.primary),
                checkColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Force changing password',
              style: textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
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
    bool obscureText = false,
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
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
