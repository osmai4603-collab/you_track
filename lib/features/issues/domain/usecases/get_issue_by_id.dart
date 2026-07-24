import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

class GetIssueById extends UseCase<Issue, GetIssueByIdParams> {
  final IssuesRepository repository;

  GetIssueById(this.repository);

  @override
  Future<Either<Failure, Issue>> call({
    required GetIssueByIdParams params,
  }) async {
    return await repository.getIssueById(params.id);
  }
}

class GetIssueByIdParams extends Params {
  final String id;

  const GetIssueByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
