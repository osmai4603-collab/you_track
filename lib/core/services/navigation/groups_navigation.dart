import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/services/navigation/app_navigation.dart';
import 'package:issues_tracking/features/groups/presentation/pages/create_group_page.dart';
import 'package:issues_tracking/features/groups/presentation/pages/groups_page.dart';

final class GroupsNavigation extends AppNavigation {
  GroupsNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.groups,
      builder: (context, state) {
        return const GroupsPage();
      },
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CreateGroupPage(),
            transitionsBuilder: AppNavigation.fadeTransition,
          ),
        ),
      ],
    ),
  ];
}
