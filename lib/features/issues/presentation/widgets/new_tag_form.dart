import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/skeleton_shimmer.dart';
import '../cubits/new_tag_cubit.dart';
import '../cubits/new_tag_state.dart';

import 'tag_permissions_section.dart';
import 'tag_subscriptions_section.dart';

class NewTagForm extends StatefulWidget {
  final String projectId;
  final String? currentIssueId;

  const NewTagForm({
    super.key,
    required this.projectId,
    this.currentIssueId,
  });

  @override
  State<NewTagForm> createState() => _NewTagFormState();
}

class _NewTagFormState extends State<NewTagForm> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    context.read<NewTagCubit>().loadMembers(widget.projectId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<NewTagCubit, NewTagState>(
      builder: (context, state) {
        return Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: localization.tagNameLabel,
                hintText: localization.tagNameHint,
                errorText: state.nameError,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => context.read<NewTagCubit>().updateName(value),
            ),
            _buildOwnerDropdown(context, state, localization),
            SwitchListTile(
              title: Row(
                children: [
                  Text(localization.removeOnResolutionLabel),
                  const SizedBox(width: 8),
                  const Tooltip(
                    message: 'Auto-remove tag from issue when it is resolved',
                    child: Icon(Icons.help_outline, size: 16, color: Colors.grey),
                  ),
                ],
              ),
              value: state.removeOnResolution,
              onChanged: (value) =>
                  context.read<NewTagCubit>().updateRemoveOnResolution(value),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text(localization.sharedLabel),
              value: state.shared,
              onChanged: (value) => context.read<NewTagCubit>().updateShared(value),
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text(localization.favoriteLabel),
              value: state.favorite,
              onChanged: (value) =>
                  context.read<NewTagCubit>().updateFavorite(value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const TagPermissionsSection(),
            const TagSubscriptionsSection(),
          ],
        );
      },
    );
  }

  Widget _buildOwnerDropdown(
    BuildContext context,
    NewTagState state,
    AppLocalizations localization,
  ) {
    if (state.status == NewTagStatus.loading) {
      return const Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Owner', style: TextStyle(fontSize: 12, color: Colors.grey)),
          SkeletonShimmer(height: 48),
        ],
      );
    }

    return DropdownButtonFormField<String>(
      value: state.ownerId,
      decoration: const InputDecoration(
        labelText: 'Owner',
        border: OutlineInputBorder(),
      ),
      items: state.members.map((member) {
        return DropdownMenuItem(
          value: member.id,
          child: Text(member.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          context.read<NewTagCubit>().updateOwner(value);
        }
      },
    );
  }
}
