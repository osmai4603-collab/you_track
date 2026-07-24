import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_state.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/priority_icon.dart';

class IssueDetailPanel extends StatelessWidget {
  const IssueDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        if (state is! IssuesLoaded || state.selectedIssueId == null) {
          return const SizedBox.shrink();
        }

        final issue = state.filteredIssues.firstWhere(
          (i) => i.id == state.selectedIssueId,
          orElse: () => state.filteredIssues.first,
        );

        return Container(
          width: 500,
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(
              left: BorderSide(color: colors.outlineVariant),
            ),
          ),
          child: Column(
            children: [
              _DetailHeader(
                issue: issue,
                colors: colors,
                textTheme: textTheme,
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _IssueTitle(
                        issue: issue,
                        colors: colors,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: AppSpacing.large),
                      _FieldsSection(
                        issue: issue,
                        colors: colors,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: AppSpacing.large),
                      _DescriptionSection(
                        issue: issue,
                        colors: colors,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: AppSpacing.large),
                      _ActivitySection(
                        issue: issue,
                        colors: colors,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final Issue issue;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _DetailHeader({
    required this.issue,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: Row(
        children: [
          Text(
            issue.fullId,
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          GestureDetector(
            onTap: () {
              context.read<IssuesBloc>().add(ToggleStarIssue(issue.id));
            },
            child: Icon(
              issue.isStarred ? Icons.star : Icons.star_border,
              size: 18,
              color: issue.isStarred
                  ? Colors.amber
                  : colors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              context.read<IssuesBloc>().add(const SelectIssue(null));
            },
            tooltip: 'Close',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _IssueTitle extends StatelessWidget {
  final Issue issue;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _IssueTitle({
    required this.issue,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      issue.title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
    );
  }
}

class _FieldsSection extends StatelessWidget {
  final Issue issue;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _FieldsSection({
    required this.issue,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _FieldRow(
            label: 'State',
            child: _StateChip(state: issue.state, textTheme: textTheme),
            colors: colors,
            textTheme: textTheme,
          ),
          _FieldRow(
            label: 'Priority',
            child: Row(
              children: [
                PriorityIcon(priority: issue.priority, size: 14),
                const SizedBox(width: 6),
                Text(
                  issue.priority.label,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
            colors: colors,
            textTheme: textTheme,
          ),
          _FieldRow(
            label: 'Type',
            child: Row(
              children: [
                Icon(issue.issueType.icon, size: 14, color: issue.issueType.color),
                const SizedBox(width: 6),
                Text(
                  issue.issueType.label,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
            colors: colors,
            textTheme: textTheme,
          ),
          _FieldRow(
            label: 'Assignee',
            child: issue.assigneeName != null
                ? Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colors.primaryContainer,
                        child: Text(
                          issue.assigneeName![0].toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.onPrimaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        issue.assigneeName!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Unassigned',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
            colors: colors,
            textTheme: textTheme,
          ),
          _FieldRow(
            label: 'Reporter',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: colors.tertiaryContainer,
                  child: Text(
                    issue.reporterName[0].toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onTertiaryContainer,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  issue.reporterName,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
            colors: colors,
            textTheme: textTheme,
          ),
          if (issue.tags.isNotEmpty)
            _FieldRow(
              label: 'Tags',
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: issue.tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                )).toList(),
              ),
              colors: colors,
              textTheme: textTheme,
            ),
          if (issue.estimation != null)
            _FieldRow(
              label: 'Estimation',
              child: Text(
                _formatDuration(issue.estimation!),
                style: textTheme.bodySmall?.copyWith(color: colors.onSurface),
              ),
              colors: colors,
              textTheme: textTheme,
            ),
          if (issue.spentTime != null)
            _FieldRow(
              label: 'Spent time',
              child: Text(
                _formatDuration(issue.spentTime!),
                style: textTheme.bodySmall?.copyWith(color: colors.onSurface),
              ),
              colors: colors,
              textTheme: textTheme,
            ),
          _FieldRow(
            label: 'Created',
            child: Text(
              _formatDate(issue.createdAt),
              style: textTheme.bodySmall?.copyWith(color: colors.onSurface),
            ),
            colors: colors,
            textTheme: textTheme,
            isLast: true,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  final ColorScheme colors;
  final TextTheme textTheme;
  final bool isLast;

  const _FieldRow({
    required this.label,
    required this.child,
    required this.colors,
    required this.textTheme,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : AppSpacing.small,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final Issue issue;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _DescriptionSection({
    required this.issue,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            issue.description.isNotEmpty
                ? issue.description
                : 'No description provided.',
            style: textTheme.bodySmall?.copyWith(
              color: issue.description.isNotEmpty
                  ? colors.onSurface
                  : colors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivitySection extends StatelessWidget {
  final Issue issue;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _ActivitySection({
    required this.issue,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        _ActivityTab(
          icon: Icons.chat_bubble_outline,
          label: 'Comments',
          count: issue.commentsCount,
          colors: colors,
          textTheme: textTheme,
        ),
        _ActivityTab(
          icon: Icons.attach_file,
          label: 'Attachments',
          count: issue.attachmentsCount,
          colors: colors,
          textTheme: textTheme,
        ),
        _ActivityTab(
          icon: Icons.history,
          label: 'History',
          count: 0,
          colors: colors,
          textTheme: textTheme,
        ),
      ],
    );
  }
}

class _ActivityTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _ActivityTab({
    required this.icon,
    required this.label,
    required this.count,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.small,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: colors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.small),
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurface,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  final IssueTrackState state;
  final TextTheme textTheme;

  const _StateChip({required this.state, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: state.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        state.label,
        style: textTheme.labelSmall?.copyWith(
          color: state.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
