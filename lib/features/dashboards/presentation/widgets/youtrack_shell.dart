

import 'package:flutter/material.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/dashboard_body_header.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/dashboard_sidebar.dart';

class YouTrackShell extends StatelessWidget {
  final Widget body;
  const YouTrackShell({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          YouTrackSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                YouTrackContentHeader(),
                Expanded(
                  child: body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}