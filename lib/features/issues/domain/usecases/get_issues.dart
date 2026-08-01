import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

class GetIssues extends UseCasePermission<List<Issue>, GetIssuesParams> {
  final IssuesRepository repository;

  GetIssues(this.repository);

  @override
  Future<Either<Failure, List<Issue>>> call({
    required GetIssuesParams params,
  }) async {
    return await repository.getIssues(params.filter);
  }
}

class GetIssuesParams extends Params {
  final IssueFilter filter;

  const GetIssuesParams({this.filter = const IssueFilter()});

  @override
  List<Object?> get props => [filter];
}
