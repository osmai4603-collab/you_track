import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../cubits/custom_fields_cubit.dart';

enum AccessLevel {
  everyone,
  adminsOnly,
  custom,
}

class MakePrivateDialog extends StatefulWidget {
  final CustomFieldEntity field;

  const MakePrivateDialog({
    super.key,
    required this.field,
  });

  @override
  State<MakePrivateDialog> createState() => _MakePrivateDialogState();
}

class _MakePrivateDialogState extends State<MakePrivateDialog> {
  AccessLevel _accessLevel = AccessLevel.everyone;
  final Set<String> _selectedGroupIds = {};
  final Set<String> _selectedUserIds = {};
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeFromField();
  }

  void _initializeFromField() {
    final accessControl = widget.field.accessControl;
    if (accessControl != null) {
      if (accessControl['admins_only'] == true) {
        _accessLevel = AccessLevel.adminsOnly;
      } else {
        final groups = accessControl['groups'] as List?;
        final users = accessControl['users'] as List?;
        if ((groups != null && groups.isNotEmpty) ||
            (users != null && users.isNotEmpty)) {
          _accessLevel = AccessLevel.custom;
          if (groups != null) {
            _selectedGroupIds.addAll(groups.cast<String>());
          }
          if (users != null) {
            _selectedUserIds.addAll(users.cast<String>());
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Configure Access: ${widget.field.name}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAccessLevelSection(colors, textTheme),
                    if (_accessLevel == AccessLevel.custom) ...[
                      const SizedBox(height: AppSpacing.medium),
                      _buildSearchField(colors),
                      const SizedBox(height: AppSpacing.small),
                      _buildGroupsSection(colors, textTheme),
                      const SizedBox(height: AppSpacing.medium),
                      _buildUsersSection(colors, textTheme),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  FilledButton(
                    onPressed: _saveAccessControl,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessLevelSection(ColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who can see this field?',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.small),
        _buildRadioOption(
          value: AccessLevel.everyone,
          title: 'Everyone',
          subtitle: 'All team members can see this field',
          colors: colors,
          textTheme: textTheme,
        ),
        _buildRadioOption(
          value: AccessLevel.adminsOnly,
          title: 'Admins only',
          subtitle: 'Only administrators can see this field',
          colors: colors,
          textTheme: textTheme,
        ),
        _buildRadioOption(
          value: AccessLevel.custom,
          title: 'Custom',
          subtitle: 'Select specific groups or users',
          colors: colors,
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required AccessLevel value,
    required String title,
    required String subtitle,
    required ColorScheme colors,
    required TextTheme textTheme,
  }) {
    return RadioListTile<AccessLevel>(
      value: value,
      groupValue: _accessLevel,
      onChanged: (newValue) {
        setState(() {
          _accessLevel = newValue!;
        });
      },
      title: Text(title, style: textTheme.bodyMedium),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSearchField(ColorScheme colors) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search groups or users...',
        prefixIcon: const Icon(Icons.search, size: 20),
        isDense: true,
        border: const OutlineInputBorder(),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildGroupsSection(ColorScheme colors, TextTheme textTheme) {
    final groups = ['Developers', 'Designers', 'QA Team', 'DevOps'];
    final filteredGroups = _searchQuery.isEmpty
        ? groups
        : groups
            .where((g) => g.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Groups',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.small),
        if (filteredGroups.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
            child: Text(
              'No groups found',
              style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          )
        else
          ...filteredGroups.map((group) => CheckboxListTile(
                value: _selectedGroupIds.contains(group),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedGroupIds.add(group);
                    } else {
                      _selectedGroupIds.remove(group);
                    }
                  });
                },
                title: Text(group, style: textTheme.bodyMedium),
                dense: true,
                contentPadding: EdgeInsets.zero,
              )),
      ],
    );
  }

  Widget _buildUsersSection(ColorScheme colors, TextTheme textTheme) {
    final users = ['John Doe', 'Jane Smith', 'Bob Johnson', 'Alice Brown'];
    final filteredUsers = _searchQuery.isEmpty
        ? users
        : users
            .where((u) => u.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Users',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.small),
        if (filteredUsers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
            child: Text(
              'No users found',
              style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          )
        else
          ...filteredUsers.map((user) => CheckboxListTile(
                value: _selectedUserIds.contains(user),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedUserIds.add(user);
                    } else {
                      _selectedUserIds.remove(user);
                    }
                  });
                },
                title: Text(user, style: textTheme.bodyMedium),
                dense: true,
                contentPadding: EdgeInsets.zero,
              )),
      ],
    );
  }

  void _saveAccessControl() {
    Map<String, dynamic>? accessControl;

    switch (_accessLevel) {
      case AccessLevel.everyone:
        accessControl = null;
        break;
      case AccessLevel.adminsOnly:
        accessControl = {'admins_only': true};
        break;
      case AccessLevel.custom:
        accessControl = {
          if (_selectedGroupIds.isNotEmpty)
            'groups': _selectedGroupIds.toList(),
          if (_selectedUserIds.isNotEmpty)
            'users': _selectedUserIds.toList(),
        };
        break;
    }

    if (accessControl != null) {
      context.read<CustomFieldsCubit>().updateAccessControl(
            fieldId: widget.field.id,
            accessControl: accessControl,
          );
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _accessLevel == AccessLevel.everyone
              ? 'Field is now visible to everyone'
              : 'Access control updated',
        ),
      ),
    );
  }
}
