import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/services/navigation/app_navigation.dart';
import 'package:issues_tracking/features/users/presentation/pages/users_page.dart';
import 'package:issues_tracking/features/users/presentation/pages/user_profile_page.dart';

final class UsersNavigation extends AppNavigation {
  UsersNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.users,
      builder: (context, state) {
        return const UsersPage();
      },
      routes: [
        GoRoute(
          path: ':userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return UserProfilePage(userId: userId);
          },
        ),
      ],
    ),
  ];
}
