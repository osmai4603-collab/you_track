import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_detail_panel.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_table_view.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_list_view.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_tree_view.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';

class IssuesPage extends StatefulWidget {
  final String? projectId;
  const IssuesPage({super.key, this.projectId});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  final _searchController = TextEditingController();
  final _key = GlobalKey<PopupMenuButtonState>();
  final _menuController = MenuController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.projectId != null) {
          context.read<IssuesBloc>().add(
                UpdateFilter(IssueFilter(projectFilter: widget.projectId)),
              );
        } else {
          context.read<IssuesBloc>().add(const LoadIssues());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssuesBloc, IssuesState>(
      builder: (context, state) {
        final showPanel = state is IssuesLoaded && state.selectedIssueId != null;
        Widget content;

        if (state is IssuesLoading) {
          content = ShimmerLoading.list(
            key: const ValueKey('issues-loading'),
            itemCount: 6,
          );
        } else if (state is IssuesError) {
          content = Center(
            key: const ValueKey('issues-error'),
            child: SelectableText(state.message),
          );
        } else if (state is IssuesLoaded) {
          content = Stack(
            key: const ValueKey('issues-loaded'),
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(state),
                  const SizedBox(height: 8),
                  Expanded(child: _buildView(state.layoutType)),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                right: showPanel ? 0 : -500,
                top: 0,
                bottom: 0,
                width: 500,
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  color: Colors.transparent,
                  child: const IssueDetailPanel(),
                ),
              ),
            ],
          );
        } else {
          content = const SizedBox.shrink(key: ValueKey('issues-empty'));
        }

        return AnimatedContentSwitcher(child: content);
      },
    );
  }

  Widget _buildView(IssueLayoutType viewMode) {
    switch (viewMode) {
      case IssueLayoutType.table:
        return const IssuesTableView();
      case IssueLayoutType.list:
        return const IssuesListView();
      case IssueLayoutType.tree:
        return const IssuesTreeView();
    }
  }

  Widget _buildTextField(IssuesLoaded state) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 16,
        children: [
          Expanded(child: TextFormField(controller: _searchController)),
          MenuAnchor(
            reservedPadding: .all(16),
            key: _key,
            controller: _menuController,
            menuChildren: _buildPageSettingMenu(state),
            builder: (_, controller, widget) {
              return _buttonContainer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buttonContainer() {
    return IconButton.outlined(
      icon: Icon(Icons.filter_list_off_rounded, size: 20),
      onPressed: _onPressedMenu,
    );
  }

  List<Widget> _buildPageSettingMenu(IssuesLoaded state) {
    final textTheme = TextTheme.of(context);
    final colors = ColorScheme.of(context);
    const padding = EdgeInsets.symmetric(horizontal: 8.0);
    final width = 500.0;
    return [
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: width,
          child: Text('Search', style: textTheme.bodySmall),
        ),
      ),
      const SizedBox(height: 2),
      Padding(
        padding: padding,
        child: Row(
          spacing: 8,
          children: IssueSearchType.values.map((type) {
            return InkWell(
              child: Container(
                padding: padding,
                height: 25,
                alignment: .center,
                decoration: BoxDecoration(
                  border: type == state.searchType ? null : .all(width: 0.50),
                  borderRadius: .circular(4),
                  color: type == state.searchType ? colors.primary : null,
                ),

                child: Text(
                  type.name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: .bold,
                    color: type == state.searchType ? colors.onPrimary : null,
                  ),
                ),
              ),
              onTap: () {
                context.read<IssuesBloc>().add(ChangeSeachType(type: type));
              },
            );
          }).toList(),
        ),
      ),
      if (state.searchType == .simple)
        Padding(
          padding: padding,
          child: Text(
            'Narrow down search results using predefined filters and natural language',
            style: textTheme.bodySmall,
          ),
        ),
      if (state.searchType == .advanced)
        Padding(
          padding: padding,
          child: Text(
            "Use YouTrack's attribute-based query language to search with exact precision",
            style: textTheme.bodySmall,
          ),
        ),

      const SizedBox(height: 32),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: width,
          child: Text('Layout', style: textTheme.bodySmall),
        ),
      ),
      const SizedBox(height: 2),
      Padding(
        padding: padding,
        child: Row(
          spacing: 8,
          children: IssueLayoutType.values.map((type) {
            final isSelected = type == state.layoutType;
            return InkWell(
              child: Container(
                height: 25,
                padding: padding,
                alignment: .center,
                decoration: BoxDecoration(
                  border: isSelected ? null : .all(width: 0.50),
                  borderRadius: .circular(4),
                  color: isSelected ? colors.primary : null,
                ),

                child: Text(
                  type.name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: .bold,
                    color: isSelected ? colors.onPrimary : null,
                  ),
                ),
              ),
              onTap: () {
                context.read<IssuesBloc>().add(ChangeLayoutType(type: type));
              },
            );
          }).toList(),
        ),
      ),

      const SizedBox(height: 32),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: width,
          child: Text('Structure', style: textTheme.bodySmall),
        ),
      ),
      const SizedBox(height: 2),
      Padding(
        padding: padding,
        child: Row(
          spacing: 8,
          children: IssueStructureType.values.map((type) {
            final isSelected = type == state.structureType;
            return InkWell(
              child: Container(
                height: 25,
                padding: padding,
                alignment: .center,
                decoration: BoxDecoration(
                  border: isSelected ? null : .all(width: 0.50),
                  borderRadius: .circular(4),
                  color: isSelected ? colors.primary : null,
                ),

                child: Text(
                  type.name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: .bold,
                    color: isSelected ? colors.onPrimary : null,
                  ),
                ),
              ),
              onTap: () {
                context.read<IssuesBloc>().add(ChangeStructureType(type: type));
              },
            );
          }).toList(),
        ),
      ),
    ];
  }

  void _onPressedMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }
}
