import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import '../cubits/new_tag_cubit.dart';
import '../cubits/new_tag_state.dart';
import 'specific_users_picker.dart';

class TagPermissionsSection extends StatelessWidget {
  const TagPermissionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<NewTagCubit, NewTagState>(
      builder: (context, state) {
        return Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Text(
              'Permissions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildPermissionDropdown(
              context,
              'view',
              localization.tagPermissionView,
              state.permissions['view'] ?? TagPermissionScope.allMembers,
              localization,
            ),
            _buildPermissionDropdown(
              context,
              'use',
              localization.tagPermissionUse,
              state.permissions['use'] ?? TagPermissionScope.allMembers,
              localization,
            ),
            _buildPermissionDropdown(
              context,
              'edit',
              localization.tagPermissionEdit,
              state.permissions['edit'] ?? TagPermissionScope.owner,
              localization,
            ),
            if (state.permissions.values.any(
              (s) => s == TagPermissionScope.specificUsers,
            ))
              _buildSpecificUsersSummary(context, state),
          ],
        );
      },
    );
  }

  Widget _buildPermissionDropdown(
    BuildContext context,
    String type,
    String label,
    TagPermissionScope currentScope,
    AppLocalizations localization,
  ) {
    final textTheme = TextTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall?.copyWith(fontWeight: .bold)),
        DropdownButton<TagPermissionScope>(
          value: currentScope,
          isExpanded: true,
          style: textTheme.labelSmall?.copyWith(fontWeight: .bold),
          underline: Container(height: 1, color: Colors.grey[400]),
          items: TagPermissionScope.values.map((scope) {
            return DropdownMenuItem(
              value: scope,
              child: Text(scope.displayName(localization)),
            );
          }).toList(),
          onChanged: (scope) {
            if (scope != null) {
              context.read<NewTagCubit>().updatePermission(type, scope);
              if (scope == TagPermissionScope.specificUsers) {
                _showSpecificUsersPicker(context);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildSpecificUsersSummary(BuildContext context, NewTagState state) {
    return InkWell(
      onTap: () => _showSpecificUsersPicker(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.people_outline, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              '${state.specificUserIds.length} users, ${state.specificGroupIds.length} groups selected',
              style: const TextStyle(color: Colors.blue),
            ),
            const Spacer(),
            const Icon(Icons.edit, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  void _showSpecificUsersPicker(BuildContext context) {
    final cubit = context.read<NewTagCubit>();
    SpecificUsersPicker.show(
      context,
      members: cubit.state.members,
      groups: cubit.state.projectGroups,
      initialSelectedIds: cubit.state.specificUserIds,
      initialSelectedGroupIds: cubit.state.specificGroupIds,
      onSelectionChanged: (userIds, groupIds) {
        cubit.updateSpecificUsers(userIds);
        cubit.updateSpecificGroups(groupIds);
      },
    );
  }
}
