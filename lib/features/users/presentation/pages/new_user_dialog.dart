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
  final _createFormKey = GlobalKey<FormState>();
  final _inviteFormKey = GlobalKey<FormState>();
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
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
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
    if (!_inviteFormKey.currentState!.validate()) return;
    final text = _emailTextController.text.trim();
    if (text.isEmpty) return;
    final emails = text
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (emails.isEmpty) return;
    context.read<UsersBloc>().add(InviteUsersEvent(emails: emails));
    Navigator.of(context).pop();
  }

  void _createUser() {
    if (!_createFormKey.currentState!.validate()) return;
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    context.read<UsersBloc>().add(
      CreateUserEvent(displayName: name, email: email, password: password),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment<int>(value: 0, label: Text('Invite users')),
                    ButtonSegment<int>(value: 1, label: Text('Create user')),
                  ],
                  selected: {_tabController.index},
                  onSelectionChanged: (Set<int> newSelection) {
                    _tabController.animateTo(newSelection.first);
                  },
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    // backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    //   (Set<WidgetState> states) {
                    //     if (states.contains(WidgetState.selected)) {
                    //       return colors.primary;
                    //     }
                    //     return const Color(0xFF2E2E32);
                    //   },
                    // ),
                    // foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    //   (Set<WidgetState> states) {
                    //     if (states.contains(WidgetState.selected)) {
                    //       return Colors.white;
                    //     }
                    //     return colors.onSurfaceVariant;
                    //   },
                    // ),
                    // shape: WidgetStateProperty.all<OutlinedBorder>(
                    //   RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    // ),
                    // textStyle: WidgetStateProperty.all<TextStyle>(
                    //   const TextStyle(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ),
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
                    onPressed: _tabController.index == 0
                        ? _inviteUsers
                        : _createUser,
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
    return Form(
      key: _inviteFormKey,
      child: Column(
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
          TextFormField(
            controller: _emailTextController,
            maxLines: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter at least one email';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter a space-separated list of email addresses',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTab(ColorScheme colors, TextTheme textTheme) {
    return Form(
      key: _createFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            'Full name',
            _fullNameController,
            colors,
            hintText: 'Enter full name',
            textTheme,
            validator: (val) => val == null || val.trim().isEmpty
                ? 'Please enter full name'
                : null,
          ),
          const SizedBox(height: 14),
          _buildField(
            'Email',
            _emailController,
            colors,
            textTheme,
            hintText: 'Enter email',
            validator: (val) => val == null || val.trim().isEmpty
                ? 'Please enter email'
                : (!val.contains('@') ? 'Invalid email format' : null),
          ),
          const SizedBox(height: 14),
          _buildField(
            'Password',
            _passwordController,
            colors,
            textTheme,
            obscureText: true,
            hintText: 'Enter password',
            validator: (val) => val == null || val.isEmpty
                ? 'Please enter password'
                : (val.length < 6
                      ? 'Password must be at least 6 characters'
                      : null),
          ),
          const SizedBox(height: 14),
          _buildField(
            'Confirm password',
            _confirmPasswordController,
            colors,
            textTheme,
            obscureText: true,
            hintText: 'Enter confirm password',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please confirm password';
              if (val != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
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
                style: textTheme.bodySmall?.copyWith(fontWeight: .bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    ColorScheme colors,
    TextTheme textTheme, {
    String? hintText,
    bool obscureText = false,
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
          cursorHeight: 17,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
