import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/features/app/presentation/cubit/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/app/presentation/widgets/yputrack_content_header.dart';
import 'package:issues_tracking/features/app/presentation/widgets/youtrack_sidebar.dart';

class YouTrackShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const YouTrackShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Update path in Cubit to sync header state
    final path = GoRouterState.of(context).uri.toString();

    // Using post frame callback to avoid updating state during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<YouTrackShellCubit>().updatePath(path);
      }
    });

    return Scaffold(
      body: Row(
        children: [
          const YouTrackSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const YouTrackContentHeader(),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
