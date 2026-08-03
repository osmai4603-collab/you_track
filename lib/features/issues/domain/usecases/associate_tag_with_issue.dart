import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import '../repositories/tags_repository.dart';

class AssociateTagWithIssue extends UseCase<void, AssociateTagWithIssueParams> {
  final TagsRepository repository;

  AssociateTagWithIssue(this.repository);

  @override
  Permission get requiredPermission => Permission.updateIssue;

  @override
  String? getProjectId(AssociateTagWithIssueParams params) => params.projectId;

  @override
  Future<Either<Failure, void>> call({
    required AssociateTagWithIssueParams params,
  }) {
    return repository.associateTagWithIssue(
      issueId: params.issueId,
      tagId: params.tagId,
    );
  }
}

class AssociateTagWithIssueParams extends Params {
  final String issueId;
  final String tagId;
  final String? projectId;

  const AssociateTagWithIssueParams({
    required this.issueId,
    required this.tagId,
    this.projectId,
  });

  @override
  List<Object?> get props => [issueId, tagId, projectId];
}
