import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import '../repositories/tags_repository.dart';

class AssociateTagWithIssue implements UseCase<void, AssociateTagWithIssueParams> {
  final TagsRepository repository;

  AssociateTagWithIssue(this.repository);

  @override
  Future<Either<Failure, void>> call({required AssociateTagWithIssueParams params}) {
    return repository.associateTagWithIssue(issueId: params.issueId, tagId: params.tagId);
  }
}

class AssociateTagWithIssueParams extends Params {
  final String issueId;
  final String tagId;

  const AssociateTagWithIssueParams({required this.issueId, required this.tagId});

  @override
  List<Object?> get props => [issueId, tagId];
}
