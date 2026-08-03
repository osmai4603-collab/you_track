import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';

final class GanttChartNavigation extends StatefulShellBranch {
  GanttChartNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.ganttChart,
      builder: (context, state) => Container(),
    ),
  ];
}
