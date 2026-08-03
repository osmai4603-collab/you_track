




import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/issues/domain/repositories/tags_repository.dart';

final class GetTagsByIssueId extends UseCase<List<Tag>, GetByIssueIdParams> {
  final TagsRepository repository;

  GetTagsByIssueId(this.repository);

  @override
  Future<Either<Failure, List<Tag>>> call({required GetByIssueIdParams params}) {
    return repository.getTagsByIssueId(issueId: params.issueId);
  }
}


final class GetLinksByIssueId extends UseCase<List<IssueLink>, GetByIssueIdParams> {
  final TagsRepository repository;

  const GetLinksByIssueId( this.repository);


  @override
  Future<Either<Failure, List<IssueLink>>> call({required GetByIssueIdParams params}) {
    return repository.getLinksByIssueId(issueId: params.issueId);
  }
}


final class GetByIssueIdParams extends Params {
  final String issueId;

  const GetByIssueIdParams({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}