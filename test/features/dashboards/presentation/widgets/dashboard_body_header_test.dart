import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/dashboard_body_header.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';

class DummyIssuesRepository implements IssuesRepository {
  @override
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter) async =>
      const Right([]);

  @override
  Future<Either<Failure, Issue>> getIssueById(String id) async =>
      const Left(ServerFailure('not implemented'));

  @override
  Future<Either<Failure, List<String>>> getAllTags() async => const Right([]);
}

void main() {
  late GoRouter router;
  String navigatedPath = '';

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      anonKey: 'test-anon-key',
    );
  });

  setUp(() {
    navigatedPath = '';

    router = GoRouter(
      initialLocation: '/projects',
      routes: [
        GoRoute(
          path: '/projects',
          builder: (context, state) =>
              const Scaffold(body: YouTrackContentHeader()),
        ),
        GoRoute(
          path: '/projects/templates',
          builder: (context, state) {
            navigatedPath = '/projects/templates';
            return const Scaffold(body: Text('Template Selection'));
          },
        ),
      ],
    );
  });

  tearDown(() {
    router.dispose();
  });

  Widget buildTestWidget() {
    final shellCubit = YouTrackShellCubit();
    shellCubit.updatePath('/projects');

    final repo = DummyIssuesRepository();
    final issuesBloc = IssuesBloc(
      getIssues: GetIssues(repo),
      repository: repo,
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<YouTrackShellCubit>.value(value: shellCubit),
          BlocProvider<IssuesBloc>.value(value: issuesBloc),
        ],
        child: child!,
      ),
    );
  }

  testWidgets(
    'tapping "Create Project" navigates to template selection',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final createButton = find.text('Create Project');
      expect(createButton, findsOneWidget);

      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(navigatedPath, '/projects/templates');
    },
  );
}
