import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/dashboards/presentation/pages/dashboard_page.dart';

final class DashboardNavigation extends StatefulShellBranch {
  DashboardNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
  ];
}
