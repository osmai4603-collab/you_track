import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';

final class TimeSheetsNavigation extends StatefulShellBranch {
  TimeSheetsNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.timeSheets,
      builder: (context, state) => Container(),
    ),
  ];
}
