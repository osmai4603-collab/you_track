import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class RemoveGroupRoleParams extends Params {
  final String groupId;
  final String projectId;

  const RemoveGroupRoleParams({required this.groupId, required this.projectId});
}

class RemoveGroupRole implements UseCase<void, RemoveGroupRoleParams> {
  final GroupsRepository repository;

  RemoveGroupRole(this.repository);

  @override
  Future<Either<Failure, void>> call({required RemoveGroupRoleParams params}) {
    return repository.removeGroupRole(params.groupId, params.projectId);
  }
}
