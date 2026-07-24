import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';

class IssuesToolbar extends StatefulWidget {
  const IssuesToolbar({super.key});

  @override
  State<IssuesToolbar> createState() => _IssuesToolbarState();
}

class _IssuesToolbarState extends State<IssuesToolbar> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        final filter = state is IssuesLoaded
            ? state.filter
            : const IssueFilter();
        final resultCount = state is IssuesLoaded
            ? state.filteredIssues.length
            : 0;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(bottom: BorderSide(color: colors.outlineVariant)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _NewIssueButton(colors: colors, textTheme: textTheme),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: _SearchBox(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  _SortDropdown(
                    filter: filter,
                    colors: colors,
                    textTheme: textTheme,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  if (state is IssuesLoaded && state.hasSelection)
                    _BulkActionsBar(
                      selectedCount: state.selectedIssueIds.length,
                      colors: colors,
                      textTheme: textTheme,
                    )
                  else
                    Text(
                      '$resultCount results',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  const Spacer(),
                  _ViewModeToggle(colors: colors, textTheme: textTheme),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NewIssueButton extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _NewIssueButton({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 16),
      label: Text(
        'New Issue',
        style: textTheme.labelMedium?.copyWith(color: colors.onPrimary),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

class _SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _SearchBox({
    required this.controller,
    required this.focusNode,
    required this.colors,
    required this.textTheme,
  });

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey.keyId == 0x0000002F &&
            !_isFocused) {
          widget.focusNode.requestFocus();
        }
      },
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: widget.textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: 'Search issues... (press / to focus)',
          hintStyle: widget.textTheme.bodySmall?.copyWith(
            color: widget.colors.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 16,
            color: widget.colors.onSurfaceVariant,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
            vertical: AppSpacing.small,
          ),
          filled: true,
          fillColor: widget.colors.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: _isFocused
                  ? widget.colors.primary
                  : widget.colors.outlineVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: widget.colors.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: widget.colors.primary, width: 1.5),
          ),
        ),
        onChanged: (value) {
          final bloc = context.read<IssuesBloc>();
          final currentFilter = (bloc.state is IssuesLoaded)
              ? (bloc.state as IssuesLoaded).filter
              : const IssueFilter();
          bloc.add(UpdateFilter(currentFilter.copyWith(searchQuery: value)));
        },
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final IssueFilter filter;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _SortDropdown({
    required this.filter,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<IssueSortField>(
      tooltip: 'Sort by',
      onSelected: (field) {
        context.read<IssuesBloc>().add(ChangeSort(field));
      },
      itemBuilder: (context) => IssueSortField.values.map((field) {
        final isSelected = filter.sortField == field;
        return AppPopupMenuItem<IssueSortField>(
          value: field,
          child: Row(
            children: [
              Text(
                field.label,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : null,
                  color: isSelected ? colors.primary : null,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  filter.sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 14,
                  color: colors.primary,
                ),
              ],
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colors.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 16, color: colors.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              filter.sortField.label,
              style: textTheme.labelMedium?.copyWith(color: colors.onSurface),
            ),
            const SizedBox(width: 4),
            Icon(
              filter.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 12,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _BulkActionsBar extends StatelessWidget {
  final int selectedCount;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _BulkActionsBar({
    required this.selectedCount,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$selectedCount selected',
          style: textTheme.labelMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        IconButton(
          icon: const Icon(Icons.select_all, size: 18),
          onPressed: () => context.read<IssuesBloc>().add(SelectAllIssues()),
          tooltip: 'Select all',
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(Icons.deselect, size: 18),
          onPressed: () => context.read<IssuesBloc>().add(DeselectAllIssues()),
          tooltip: 'Deselect all',
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow, size: 18),
          onPressed: () {},
          tooltip: 'Apply command',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _ViewModeToggle({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        final currentMode = state is IssuesLoaded
            ? state.viewMode
            : IssueViewMode.table;

        return Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ViewModeButton(
                icon: Icons.table_rows,
                tooltip: 'Table view',
                mode: IssueViewMode.table,
                isSelected: currentMode == IssueViewMode.table,
                colors: colors,
                textTheme: textTheme,
              ),
              _ViewModeButton(
                icon: Icons.view_list,
                tooltip: 'List view',
                mode: IssueViewMode.list,
                isSelected: currentMode == IssueViewMode.list,
                colors: colors,
                textTheme: textTheme,
              ),
              _ViewModeButton(
                icon: Icons.account_tree,
                tooltip: 'Tree view',
                mode: IssueViewMode.tree,
                isSelected: currentMode == IssueViewMode.tree,
                colors: colors,
                textTheme: textTheme,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final IssueViewMode mode;
  final bool isSelected;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _ViewModeButton({
    required this.icon,
    required this.tooltip,
    required this.mode,
    required this.isSelected,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 18,
        color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
      ),
      onPressed: isSelected
          ? null
          : () {
              context.read<IssuesBloc>().add(ChangeViewMode(mode));
            },
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: isSelected ? colors.primary : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.all(8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
