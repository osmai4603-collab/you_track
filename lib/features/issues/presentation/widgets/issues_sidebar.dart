import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';

class IssuesSidebar extends StatelessWidget {
  const IssuesSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 250,
      color: colors.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Issues',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                BlocBuilder<IssuesBloc, IssuesState>(
                  builder: (context, state) {
                    final count = state is IssuesLoaded ? state.issues.length : 0;
                    return Text(
                      '$count',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<IssuesBloc, IssuesState>(
              builder: (context, state) {
                if (state is IssuesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IssuesLoaded) {
                  return _IssueList(issues: state.issues);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueList extends StatelessWidget {
  final List<Issue> issues;

  const _IssueList({required this.issues});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.extraSmall,
        vertical: AppSpacing.extraSmall,
      ),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return _IssueListTile(issue: issue, colors: colors);
      },
    );
  }
}

class _IssueListTile extends StatelessWidget {
  final Issue issue;
  final ColorScheme colors;

  const _IssueListTile({required this.issue, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          context.read<IssuesBloc>().add(SelectIssue(issue.id));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.extraSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: issue.state.textColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.extraSmall),
                  Expanded(
                    child: Text(
                      issue.fullId,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    issue.priority.icon,
                    size: 12,
                    color: issue.priority.color,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                issue.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
