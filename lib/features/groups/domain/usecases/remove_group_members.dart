import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class RemoveGroupMembersParams extends Params {
  final String groupId;
  final List<String> userIds;

  const RemoveGroupMembersParams({
    required this.groupId,
    required this.userIds,
  });

  @override
  List<Object?> get props => [groupId, userIds];
}

class RemoveGroupMembers extends UseCase<void, RemoveGroupMembersParams> {
  final GroupsRepository repository;

  RemoveGroupMembers(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required RemoveGroupMembersParams params,
  }) {
    return repository.removeGroupMembers(params.groupId, params.userIds);
  }
}
