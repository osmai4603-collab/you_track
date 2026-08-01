import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';
import 'package:issues_tracking/features/roles/presentation/pages/role_form_page.dart';
import 'package:issues_tracking/features/roles/presentation/widgets/roles_table_view.dart';

class RolesPage extends StatefulWidget {
  final String? userId;

  const RolesPage({super.key, this.userId});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RolesBloc>().add(const LoadRoles());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        final showPanel = state is RolesLoaded && state.selectedRoleId != null;
        if (state is RolesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RolesError) {
          return Center(child: SelectableText(state.message));
        } else if (state is RolesLoaded) {
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildSearchField()),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () =>
                              context.push(AppRouteKeys.createRole),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add role'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: RolesTableView(userId: widget.userId)),
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
                  child: const RoleFormPage(),
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
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search roles...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
