import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/agile_boards/presentation/pages/agile_board_view_page.dart';
import 'package:issues_tracking/features/agile_boards/presentation/pages/agile_boards_list_page.dart';

final class AgileBoardsNavigation extends StatefulShellBranch {
  AgileBoardsNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.agileBoards,
      builder: (context, state) => const AgileBoardsListPage(),
      routes: [
        GoRoute(
          path: ':projectId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final projectName = state.extra as String? ?? 'Project';
            return AgileBoardViewPage(
              projectId: projectId,
              projectName: projectName,
            );
          },
        ),
      ],
    ),
  ];
}
