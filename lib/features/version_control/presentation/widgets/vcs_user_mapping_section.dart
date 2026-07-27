import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';

class VcsUserMappingSection extends StatefulWidget {
  final VcsIntegrationEntity integration;

  const VcsUserMappingSection({super.key, required this.integration});

  @override
  State<VcsUserMappingSection> createState() => _VcsUserMappingSectionState();
}

class _VcsUserMappingSectionState extends State<VcsUserMappingSection> {
  List<VcsUserMappingEntity> _mappings = [];
  bool _isLoading = true;
  final _emailController = TextEditingController();
  final _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMappings();
  }

  Future<void> _loadMappings() async {
    setState(() => _isLoading = true);
    final mappings = await context
        .read<VcsIntegrationsCubit>()
        .loadUserMappings(widget.integration.id);
    setState(() {
      _mappings = mappings;
      _isLoading = false;
    });
  }

  void _showAddMappingDialog() {
    _emailController.clear();
    _userIdController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add User Mapping'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'VCS email or username',
                    hintText: 'e.g. developer@example.com',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    labelText: 'YouTrack User ID',
                    hintText: 'UUID of the target user',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final userId = _userIdController.text.trim();
                if (email.isEmpty || userId.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Both fields are required')),
                  );
                  return;
                }
                final mapping = VcsUserMappingEntity(
                  id: '',
                  integrationId: widget.integration.id,
                  vcsUsernameOrEmail: email,
                  youtrackUserId: userId,
                  createdAt: DateTime.now(),
                );
                context.read<VcsIntegrationsCubit>().addUserMapping(mapping);
                Navigator.of(dialogContext).pop();
                _loadMappings();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(VcsUserMappingEntity mapping) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Mapping'),
          content: Text(
            'Remove mapping for "${mapping.vcsUsernameOrEmail}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                context.read<VcsIntegrationsCubit>().deleteUserMapping(
                      widget.integration.id,
                      mapping.id,
                    );
                Navigator.of(dialogContext).pop();
                _loadMappings();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_outline, size: 18, color: colors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.small),
            Text(
              'User Mappings',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: _showAddMappingDialog,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add mapping'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          'Manual email/username overrides for user attribution. '
          'Manual mappings take precedence over automatic email matching.',
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.medium),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_mappings.isEmpty)
          _buildEmptyState(colors, textTheme)
        else
          _buildMappingsList(colors, textTheme),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colors, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_add_outlined,
            size: 32,
            color: colors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'No user mappings configured',
            style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(
            'Add mappings to override automatic email matching.',
            style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildMappingsList(ColorScheme colors, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'VCS Email / Username',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'YouTrack User ID',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          const Divider(height: 1),
          ..._mappings.map((mapping) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small + 2,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      mapping.vcsUsernameOrEmail,
                      style: textTheme.bodySmall?.copyWith(
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      mapping.youtrackUserId,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      icon: Icon(Icons.delete_outline,
                          size: 16, color: colors.error),
                      onPressed: () => _confirmDelete(mapping),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userIdController.dispose();
    super.dispose();
  }
}
