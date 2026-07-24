import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_toolbar.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_table_view.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_list_view.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issues_tree_view.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_detail_panel.dart';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const IssuesToolbar(),
        Expanded(
          child: BlocBuilder<IssuesBloc, IssuesState>(
            builder: (context, state) {
              if (state is IssuesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is IssuesError) {
                return Center(child: Text(state.message));
              } else if (state is IssuesLoaded) {
                return Row(
                  children: [
                    Expanded(child: _buildView(state.viewMode)),
                    if (state.selectedIssueId != null) const IssueDetailPanel(),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildView(IssueViewMode viewMode) {
    switch (viewMode) {
      case IssueViewMode.table:
        return const IssuesTableView();
      case IssueViewMode.list:
        return const IssuesListView();
      case IssueViewMode.tree:
        return const IssuesTreeView();
    }
  }
}
