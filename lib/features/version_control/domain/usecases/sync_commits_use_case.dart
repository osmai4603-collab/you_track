import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class SyncCommitsUseCase
    extends UseCasePermission<List<VcsCommitEntity>, SyncCommitsParams> {
  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  final VersionControlRepository repository;

  SyncCommitsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VcsCommitEntity>>> call(
      {required SyncCommitsParams params}) {
    return repository.getCommits(params.integrationId, taskId: params.taskId);
  }
}

class SyncCommitsParams extends Params {
  final String integrationId;
  final String? taskId;

  const SyncCommitsParams({required this.integrationId, this.taskId});

  @override
  List<Object?> get props => [integrationId, taskId];
}
