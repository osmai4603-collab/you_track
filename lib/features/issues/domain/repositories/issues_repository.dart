import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';

abstract class IssuesRepository {
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter);
  Future<Either<Failure, Issue>> getIssueById(String id);
  Future<Either<Failure, List<String>>> getAllTags();
}
