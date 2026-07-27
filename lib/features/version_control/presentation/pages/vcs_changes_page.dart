import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/vcs_pr_state_enum.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_pull_request_entity.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';

class VcsChangesPage extends StatefulWidget {
  final String projectId;

  const VcsChangesPage({super.key, required this.projectId});

  @override
  State<VcsChangesPage> createState() => _VcsChangesPageState();
}

class _VcsChangesPageState extends State<VcsChangesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<VcsIntegrationEntity> _integrations = [];
  VcsIntegrationEntity? _selectedIntegration;
  List<VcsCommitEntity> _commits = [];
  List<VcsPullRequestEntity> _pullRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final cubit = context.read<VcsIntegrationsCubit>();
    await cubit.loadIntegrations(widget.projectId);

    final state = cubit.state;
    if (state is VcsIntegrationsLoaded) {
      _integrations = state.integrations;
      if (_integrations.isNotEmpty) {
        _selectedIntegration = _integrations.first;
        await _loadIntegrationData(_integrations.first);
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loadIntegrationData(VcsIntegrationEntity integration) async {
    final cubit = context.read<VcsIntegrationsCubit>();
    final commits = await cubit.loadCommits(integration.id);
    final prs = await cubit.loadCommits(integration.id);
    setState(() {
      _commits = commits;
      _pullRequests = prs.cast<VcsPullRequestEntity>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(colors, textTheme),
          const SizedBox(height: AppSpacing.medium),
          if (_integrations.isNotEmpty) ...[
            _buildIntegrationSelector(colors, textTheme),
            const SizedBox(height: AppSpacing.medium),
            _buildTabs(colors, textTheme),
          ],
          const SizedBox(height: AppSpacing.medium),
          Expanded(child: _buildContent(colors, textTheme)),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors, TextTheme textTheme) {
    return Row(
      children: [
        Icon(Icons.commit, color: colors.primary, size: 22),
        const SizedBox(width: AppSpacing.small),
        Text(
          'VCS Changes',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (_selectedIntegration != null)
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Refresh',
          ),
      ],
    );
  }

  Widget _buildIntegrationSelector(ColorScheme colors, TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Repository:',
          style: textTheme.labelMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<VcsIntegrationEntity>(
              value: _selectedIntegration,
              isDense: true,
              items: _integrations.map((i) {
                return DropdownMenuItem(
                  value: i,
                  child: Text(
                    '${i.integrationName} (${i.repositoryName})',
                    style: textTheme.bodySmall,
                  ),
                );
              }).toList(),
              onChanged: (integration) {
                if (integration != null) {
                  setState(() => _selectedIntegration = integration);
                  _loadIntegrationData(integration);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(ColorScheme colors, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: 'Commits (${_commits.length})'),
          Tab(text: 'Pull Requests (${_pullRequests.length})'),
        ],
      ),
    );
  }

  Widget _buildContent(ColorScheme colors, TextTheme textTheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_integrations.isEmpty) {
      return _buildEmptyState(colors, textTheme);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildCommitsList(colors, textTheme),
        _buildPullRequestsList(colors, textTheme),
      ],
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
            'No VCS integrations',
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Connect a repository in Settings > Version Control\nto see commits and pull requests here.',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommitsList(ColorScheme colors, TextTheme textTheme) {
    if (_commits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.commit_outlined,
              size: 48,
              color: colors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'No commits found',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _commits.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colors.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final commit = _commits[index];
        return _buildCommitTile(commit, colors, textTheme);
      },
    );
  }

  Widget _buildCommitTile(
      VcsCommitEntity commit, ColorScheme colors, TextTheme textTheme) {
    final shortSha = commit.commitSha.length >= 7
        ? commit.commitSha.substring(0, 7)
        : commit.commitSha;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                commit.authorName.isNotEmpty
                    ? commit.authorName[0].toUpperCase()
                    : '?',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        shortSha,
                        style: textTheme.labelSmall?.copyWith(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    Text(
                      commit.authorName,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    Text(
                      _formatDate(commit.committedAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  commit.message,
                  style: textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.merge, size: 12, color: colors.onSurfaceVariant),
                    const SizedBox(width: 2),
                    Text(
                      commit.branch,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPullRequestsList(ColorScheme colors, TextTheme textTheme) {
    if (_pullRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows_outlined,
              size: 48,
              color: colors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'No pull requests found',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _pullRequests.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colors.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final pr = _pullRequests[index];
        return _buildPrTile(pr, colors, textTheme);
      },
    );
  }

  Widget _buildPrTile(
      VcsPullRequestEntity pr, ColorScheme colors, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: Row(
        children: [
          _prStateIcon(pr.state, colors),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${pr.prNumber}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.extraSmall),
                    Expanded(
                      child: Text(
                        pr.title,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${pr.authorName} • ${pr.sourceBranch} → ${pr.targetBranch}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(pr.openedAt),
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _prStateIcon(VcsPrState state, ColorScheme colors) {
    final Color color;
    final IconData icon;

    switch (state) {
      case VcsPrState.open:
        color = Colors.green;
        icon = Icons.radio_button_checked;
      case VcsPrState.merged:
        color = Colors.purple;
        icon = Icons.merge;
      case VcsPrState.closed:
        color = colors.error;
        icon = Icons.cancel_outlined;
    }

    return Icon(icon, size: 18, color: color);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
