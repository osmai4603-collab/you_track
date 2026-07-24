import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_table_row.dart';

class IssuesTableView extends StatelessWidget {
  const IssuesTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        if (state is IssuesLoaded) {
          if (state.filteredIssues.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'No issues found',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    'Try adjusting your search or filters',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _TableHeader(colors: colors, textTheme: textTheme),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredIssues.length,
                  itemBuilder: (context, index) {
                    final issue = state.filteredIssues[index];
                    return IssueTableRow(
                      issue: issue,
                      isSelected: state.selectedIssueIds.contains(issue.id),
                      isHighlighted: state.selectedIssueId == issue.id,
                      onTap: () {
                        context.read<IssuesBloc>().add(SelectIssue(issue.id));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _TableHeader({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.small,
      ),
      color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Checkbox(
              value: false,
              onChanged: (value) {
                if (value == true) {
                  context.read<IssuesBloc>().add(SelectAllIssues());
                } else {
                  context.read<IssuesBloc>().add(DeselectAllIssues());
                }
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: AppSpacing.extraSmall),
          SizedBox(
            width: 32,
            child: Text(
              '',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              'ID',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Summary',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'State',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              'Type',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Assignee',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              'Updated',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
    );
  }
}
