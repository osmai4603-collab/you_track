import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/presentation/pages/group_form_page.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/groups_table_view.dart';

class GroupsPage extends StatefulWidget {
  final String? userId;

  const GroupsPage({super.key, this.userId});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GroupsBloc>().add(const LoadGroups());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        final showPanel = state is GroupsLoaded && state.selectedGroupId != null;
        if (state is GroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GroupsError) {
          return Center(child: SelectableText(state.message));
        } else if (state is GroupsLoaded) {
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildSearchField()),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () => context.push(AppRouteKeys.createGroup),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add group'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: GroupsTableView(userId: widget.userId)),
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
                  child: const GroupFormPage(),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 30,
      child: TextFormField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search groups...',
          prefixIcon: Icon(Icons.search, size: 18),
        ),
      ),
    );
  }
}
