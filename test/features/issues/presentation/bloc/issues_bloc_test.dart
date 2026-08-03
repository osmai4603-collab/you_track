import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/stream_issues.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:mocktail/mocktail.dart';

class MockIssuesRepository extends Mock implements IssuesRepository {}

void main() {
  late MockIssuesRepository repository;
  late IssuesBloc bloc;

  setUpAll(() {
    registerFallbackValue(const IssueFilter());
  });

  setUp(() {
    repository = MockIssuesRepository();
    bloc = IssuesBloc(
      getIssues: GetIssues(repository),
      streamIssues: StreamIssues(repository),
      repository: repository,
    );
  });

  test('loads issues into both issues and filteredIssues', () async {
    final issue = Issue(
      id: 'issue-1',
      issueKey: 'PRJ-1',
      issueNumber: 1,
      summary: 'Test issue',
      reporterId: 'user-1',
      reporterName: 'Reporter',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(() => repository.getIssues(any())).thenAnswer((_) async => right(<Issue>[issue]));

    bloc.add(const LoadIssues());

    await expectLater(
      bloc.stream,
      emitsThrough(isA<IssuesLoaded>()),
    );

    final state = bloc.state;
    expect(state, isA<IssuesLoaded>());

    final loaded = state as IssuesLoaded;
    expect(loaded.issues, hasLength(1));
    expect(loaded.filteredIssues, hasLength(1));
    expect(loaded.filteredIssues.first.id, issue.id);
  });
}
