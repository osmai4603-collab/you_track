import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_table_row.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';

class IssuesTableView extends StatelessWidget {
  const IssuesTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;

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
              _TableHeader(colors: colors, textTheme: textTheme, state: state),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return Divider();
                  },
                  itemCount: state.filteredIssues.length,
                  itemBuilder: (context, index) {
                    final issue = state.filteredIssues[index];
                    return IssueTableRow(
                      localization: localization,
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

        return ShimmerLoading.table();
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;
  final IssuesLoaded state;

  const _TableHeader({
    required this.colors,
    required this.textTheme,
    required this.state,
  });

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
            width: 100,
            child: Row(
              children: [
                Checkbox(
                  value: state.selectedIssueIds.length == state.issues.length,
                  onChanged: (_) {
                    if (state.selectedIssueIds.length == state.issues.length) {
                      context.read<IssuesBloc>().add(DeselectAllIssues());
                    } else {
                      context.read<IssuesBloc>().add(SelectAllIssues());
                    }
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  activeColor: colors.primary,
                ),
                _RowField(
                  fieldName: 'ID',
                  onDeletePressed: _onDeletePressed,
                  onDesc: _onDesc,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: _RowField(
              fieldName: 'Summary',
              onDeletePressed: _onDeletePressed,
              onDesc: _onDesc,
            ),
          ),
          SizedBox(
            width: 100,
            child: _RowField(
              fieldName: 'State',
              onDeletePressed: _onDeletePressed,
              onDesc: _onDesc,
            ),
          ),
          SizedBox(
            width: 90,
            child: _RowField(
              fieldName: 'Type',
              onDeletePressed: _onDeletePressed,
              onDesc: _onDesc,
            ),
          ),
          SizedBox(
            width: 120,
            child: _RowField(
              fieldName: 'Assignee',
              onDeletePressed: _onDeletePressed,
              onDesc: _onDesc,
            ),
          ),
          SizedBox(
            width: 110,
            child: _RowField(
              fieldName: 'Created',
              onDeletePressed: _onDeletePressed,
              onDesc: _onDesc,
            ),
          ),
          SizedBox(
            width: 110,
            child: _RowField(
              fieldName: 'Priority',
              onDeletePressed: _onDeletePressed,
              onDesc: _onDesc,
            ),
          ),
        ],
      ),
    );
  }

  void _onDeletePressed() {}

  void _onDesc(bool isDesc) {}
}

class _RowField extends StatefulWidget {
  final String fieldName;
  final void Function(bool)? onDesc;
  final void Function()? onDeletePressed;
  const _RowField({
    required this.fieldName,
    this.onDesc,
    required this.onDeletePressed,
  });

  @override
  State<_RowField> createState() => __RowFieldState();
}

class __RowFieldState extends State<_RowField> {
  bool isHovered = false;
  bool isDesc = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // onHover: _onHover,
      onEnter: _onEnter,
      onExit: _onExit,
      child: Container(
        decoration: BoxDecoration(
          color: isHovered
              ? ColorScheme.of(context).primary.withValues(alpha: 0.15)
              : null,
          borderRadius: .circular(5.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            isDesc = !isDesc;
            widget.onDesc == null ? null : widget.onDesc!(isDesc);
          },
          child: Row(
            spacing: 3,
            children: [
              // if (isHovered) Icon(Icons.drag_handle_rounded, size: 13),
              Text(widget.fieldName, style: TextTheme.of(context).labelMedium),

              Icon(Icons.sort, textDirection: isDesc ? .ltr : .rtl),
              if (widget.onDeletePressed != null && isHovered)
                _DeleteButton(
                  onDeletePressed: widget.onDeletePressed!,
                  // padding: .zero,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() => isHovered = true);
  }

  void _onExit(PointerExitEvent event) {
    setState(() => isHovered = false);
  }
}

class _DeleteButton extends StatefulWidget {
  final void Function()? onDeletePressed;
  const _DeleteButton({required this.onDeletePressed});

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool isHoverd = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isHoverd ? SystemMouseCursors.precise : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHoverd = true),
      onExit: (_) => setState(() => isHoverd = false),
      child: InkWell(
        onTap: widget.onDeletePressed!,
        child: Icon(
          Icons.delete_forever_outlined,
          size: 16,
          color: isHoverd ? ColorScheme.of(context).error : null,
        ),
        // padding: .zero,
      ),
    );
  }
}
