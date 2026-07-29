import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/services/navigation/app_navigation.dart';
import 'package:issues_tracking/features/roles/presentation/pages/create_role_page.dart';
import 'package:issues_tracking/features/roles/presentation/pages/roles_page.dart';

final class RolesNavigation extends AppNavigation {
  RolesNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.roles,
      builder: (context, state) {
        return const RolesPage();
      },
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CreateRolePage(),
            transitionsBuilder: AppNavigation.fadeTransition,
          ),
        ),
      ],
    ),
  ];
}
