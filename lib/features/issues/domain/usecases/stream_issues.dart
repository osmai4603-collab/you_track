import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';

class StreamIssues {
  final IssuesRepository repository;

  StreamIssues(this.repository);

  Stream<Issue> call({required GetIssuesParams params}) {
    return repository.streamIssues(params.filter);
  }
}
