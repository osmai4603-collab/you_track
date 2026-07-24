import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 250,
      color: colors.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SidebarHeader(),
          Expanded(child: _SidebarBody()),
          _SidebarFooter(),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
          
        ],
      ),
    );
  }
}

class _SidebarBody extends StatelessWidget {
  const _SidebarBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text('Issues'),
            onTap: () => context.go(AppRouteKeys.issues),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () => context.go(AppRouteKeys.dashboard),
          ),
          ListTile(
            title: Text('Agile Board'),
            onTap: () => context.go(AppRouteKeys.board),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () => context.go(AppRouteKeys.issues),
          ),
        ],
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(title: Text('Login')),
        ListTile(title: Text('Notifications')),
      ],
    );
  }
}
