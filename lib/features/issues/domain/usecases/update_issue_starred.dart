import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/issues_repository.dart';

class UpdateIssueStarredParams extends Params {
  final String issueId;
  final bool isStarred;
  const UpdateIssueStarredParams({
    required this.issueId,
    required this.isStarred,
  });

  @override
  List<Object?> get props => [issueId, isStarred];
}

class UpdateIssueStarredUseCase extends UseCase<void, UpdateIssueStarredParams> {
  final IssuesRepository repository;

  UpdateIssueStarredUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.updateIssue;

  @override
  Future<Either<Failure, void>> call({
    required UpdateIssueStarredParams params,
  }) {
    return repository.updateIssueStarred(params.issueId, params.isStarred);
  }
}