import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/presentation/pages/group_form_page.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/groups_table_view.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';

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
    context.read<GroupsBloc>().add(LoadGroups(userId: widget.userId));
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
        Widget content;

        if (state is GroupsLoading) {
          content = ShimmerLoading.table(
            key: const ValueKey('groups-loading'),
          );
        } else if (state is GroupsError) {
          content = Center(
            key: const ValueKey('groups-error'),
            child: SelectableText(state.message),
          );
        } else if (state is GroupsLoaded) {
          content = Stack(
            key: const ValueKey('groups-loaded'),
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
                        if (context.watch<UserSession>().hasPermission(Permission.systemLowLevelAdminWrite))
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
        } else {
          content = const SizedBox.shrink(key: ValueKey('groups-empty'));
        }

        return AnimatedContentSwitcher(child: content);
      },
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
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
