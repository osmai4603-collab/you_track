import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/services/navigation/app_navigation.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issue_form.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issues_page.dart';

final class IssuesNavigation extends AppNavigation {
  IssuesNavigation() : super(routes: _routes);

  static final _routes = [
    GoRoute(
      path: AppRouteKeys.issues,
      builder: (context, state) {
        return const IssuesPage();
      },
      routes: [
        GoRoute(
          path: 'new-issue',
          pageBuilder: (_, state) {
            final projectKey = state.uri.queryParameters['project'] ?? 'DEM';
            return CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => get_it<IssueFormCubit>(),
                child: IssueForm(projectKey: projectKey),
              ),
              transitionsBuilder: AppNavigation.fadeTransition,
            );
          },
        ),

        GoRoute(
          path: ':issueId/edit',
          pageBuilder: (_, state) {
            final issueId = state.pathParameters['issueId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => get_it<IssueFormCubit>(),
                child: IssueForm(issueId: issueId),
              ),
              transitionsBuilder: AppNavigation.fadeTransition,
            );
          },
        ),
      ],
    ),
  ];
}
