import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';
import 'package:issues_tracking/features/version_control/presentation/widgets/vcs_integration_card.dart';
import 'package:issues_tracking/features/version_control/presentation/widgets/vcs_integration_form_dialog.dart';

class VersionControlSettingsSection extends StatefulWidget {
  const VersionControlSettingsSection({super.key});

  @override
  State<VersionControlSettingsSection> createState() =>
      _VersionControlSettingsSectionState();
}

class _VersionControlSettingsSectionState
    extends State<VersionControlSettingsSection> {
  @override
  void initState() {
    super.initState();
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<VcsIntegrationsCubit>().loadIntegrations(projectId);
    }
  }

  void _refresh() {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<VcsIntegrationsCubit>().loadIntegrations(projectId);
    }
  }

  void _showAddIntegrationDialog() {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId == null) return;

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<VcsIntegrationsCubit>(),
        child: VcsIntegrationFormDialog(projectId: projectId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<VcsIntegrationsCubit, VcsIntegrationsState>(
      listener: (context, state) {
        if (state is VcsIntegrationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: SelectableText(state.message),
              backgroundColor: colors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(colors, textTheme, state),
              const SizedBox(height: AppSpacing.medium),
              Expanded(child: _buildContent(state, colors, textTheme)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    ColorScheme colors,
    TextTheme textTheme,
    VcsIntegrationsState state,
  ) {
    final isLoaded = state is VcsIntegrationsLoaded;
    final count = isLoaded ? state.integrations.length : 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version Control Integrations',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count == 0
                    ? 'No integrations configured'
                    : '$count integration${count == 1 ? '' : 's'} configured',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _showAddIntegrationDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add repository'),
        ),
      ],
    );
  }

  Widget _buildContent(
    VcsIntegrationsState state,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    if (state is VcsIntegrationsInitial || state is VcsIntegrationsLoading) {
      return Center(
        key: const ValueKey('vcs-loading'),
        child: SizedBox(width: 480, child: ShimmerLoading.list(itemCount: 6)),
      );
    }

    if (state is VcsIntegrationsError && state is! VcsIntegrationsLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: AppSpacing.medium),
            Text('Failed to load integrations', style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.small),
            SelectableText(
              state.message,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            FilledButton(onPressed: _refresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    final integrations = (state as VcsIntegrationsLoaded).integrations;

    if (integrations.isEmpty) {
      return _buildEmptyState(colors, textTheme);
    }

    return ListView.separated(
      itemCount: integrations.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.medium),
      itemBuilder: (context, index) {
        final integration = integrations[index];
        return VcsIntegrationCard(
          integration: integration,
          onEdit: () => _showEditDialog(integration),
          onDelete: () => _confirmDelete(integration),
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme colors, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 64,
            color: colors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'No VCS integrations yet',
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Connect a repository to track commits and\n'
            'pull requests linked to your tasks.',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.large),
          FilledButton.icon(
            onPressed: _showAddIntegrationDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add repository'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(VcsIntegrationEntity integration) {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId == null) return;

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<VcsIntegrationsCubit>(),
        child: VcsIntegrationFormDialog(
          projectId: projectId,
          existingIntegration: integration,
        ),
      ),
    );
  }

  void _confirmDelete(VcsIntegrationEntity integration) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Integration'),
          content: Text(
            'Are you sure you want to delete "${integration.integrationName}"? '
            'This will remove all associated commits and pull request records.',
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
                context.read<VcsIntegrationsCubit>().deleteIntegration(
                  integration.id,
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
