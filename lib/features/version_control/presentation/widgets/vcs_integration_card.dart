import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/server_type_enum.dart';
import 'package:issues_tracking/core/enums/vcs_connection_status_enum.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';
import 'package:issues_tracking/features/version_control/presentation/widgets/vcs_user_mapping_section.dart';

class VcsIntegrationCard extends StatefulWidget {
  final VcsIntegrationEntity integration;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VcsIntegrationCard({
    super.key,
    required this.integration,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<VcsIntegrationCard> createState() => _VcsIntegrationCardState();
}

class _VcsIntegrationCardState extends State<VcsIntegrationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final integration = widget.integration;

    return Card(
      elevation: 0.20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outline),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, colors, textTheme),
            const SizedBox(height: AppSpacing.small),
            _buildDetails(colors, textTheme),
            const SizedBox(height: AppSpacing.small),
            _buildBadges(colors, textTheme),
            const SizedBox(height: AppSpacing.small),
            _buildExpandToggle(colors, textTheme),
            if (_isExpanded) ...[
              const Divider(height: AppSpacing.large),
              VcsUserMappingSection(integration: integration),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    final integration = widget.integration;
    return Row(
      children: [
        _buildProviderIcon(colors),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                integration.integrationName,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${integration.organizationOwner}/${integration.repositoryName}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(colors, textTheme),
        const SizedBox(width: AppSpacing.small),
        PopupMenuButton<String>(
          padding: AppSpacing.paddingAllSmall,
          borderRadius: BorderRadius.circular(4),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'test', child: Text('Test connection')),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: colors.error)),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') widget.onEdit();
            if (value == 'delete') widget.onDelete();
            if (value == 'test') _testConnection(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Icon(Icons.more_vert, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildProviderIcon(ColorScheme colors) {
    final integration = widget.integration;
    final IconData iconData;
    final Color iconColor;

    switch (integration.providerType) {
      case VcsProviderType.github:
        iconData = Icons.code;
        iconColor = Colors.black;
      case VcsProviderType.gitlab:
        iconData = Icons.code;
        iconColor = const Color(0xFFFC6D26);
      case VcsProviderType.bitbucket:
      case VcsProviderType.bitbucketServer:
        iconData = Icons.cloud;
        iconColor = const Color(0xFF2684FF);
      case VcsProviderType.gitea:
        iconData = Icons.dns;
        iconColor = const Color(0xFF609926);
      default:
        iconData = Icons.folder;
        iconColor = colors.onSurfaceVariant;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, size: 20, color: iconColor),
    );
  }

  Widget _buildDetails(ColorScheme colors, TextTheme textTheme) {
    final integration = widget.integration;
    return Wrap(
      spacing: AppSpacing.medium,
      runSpacing: AppSpacing.extraSmall,
      children: [
        _detailChip(
          Icons.vpn_key,
          _authModeLabel(integration.authMode.value),
          colors,
          textTheme,
        ),
        if (integration.serverUrl != null)
          _detailChip(Icons.link, integration.serverUrl!, colors, textTheme),
        _detailChip(
          Icons.merge,
          integration.branchSpecification,
          colors,
          textTheme,
        ),
      ],
    );
  }

  Widget _buildBadges(ColorScheme colors, TextTheme textTheme) {
    final integration = widget.integration;
    final badges = <Widget>[];

    if (integration.parseCommitsForCommands) {
      badges.add(_badge('Parse commits', colors.primary, textTheme));
    }
    if (integration.pullRequestAutomation) {
      badges.add(_badge('PR automation', Colors.teal, textTheme));
    }
    if (integration.silentProcessing) {
      badges.add(_badge('Silent', Colors.grey, textTheme));
    }
    if (integration.automaticUserMapping) {
      badges.add(_badge('Auto map users', Colors.orange, textTheme));
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.extraSmall,
      runSpacing: AppSpacing.extraSmall,
      children: badges,
    );
  }

  Widget _badge(String label, Color color, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _detailChip(
    IconData icon,
    String label,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildStatusChip(ColorScheme colors, TextTheme textTheme) {
    final integration = widget.integration;
    final Color chipColor;
    final String label;

    switch (integration.status) {
      case VcsConnectionStatus.connected:
        chipColor = Colors.green;
        label = 'Connected';
      case VcsConnectionStatus.disabled:
        chipColor = Colors.grey;
        label = 'Disabled';
      case VcsConnectionStatus.authFailed:
        chipColor = colors.error;
        label = 'Auth failed';
      case VcsConnectionStatus.syncError:
        chipColor = Colors.orange;
        label = 'Sync error';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandToggle(ColorScheme colors, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isExpanded ? 'Hide user mappings' : 'Manage user mappings',
            style: textTheme.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 16,
            color: colors.primary,
          ),
        ],
      ),
    );
  }

  String _authModeLabel(String mode) {
    switch (mode) {
      case 'oauth':
        return 'OAuth 2.0';
      case 'token':
        return 'Token';
      case 'ssh':
        return 'SSH Key';
      default:
        return mode;
    }
  }

  void _testConnection(BuildContext context) {
    context.read<VcsIntegrationsCubit>().testConnection(widget.integration.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Testing connection...')));
  }
}
