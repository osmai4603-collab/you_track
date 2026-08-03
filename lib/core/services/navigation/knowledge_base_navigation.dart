import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';

final class KnowledgeBaseNavigation extends StatefulShellBranch {
  KnowledgeBaseNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.knowldgeBase,
      builder: (context, state) => Container(),
    ),
  ];
}
