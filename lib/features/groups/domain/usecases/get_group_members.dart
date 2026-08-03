import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class GetGroupMembersParams extends Params {
  final String groupId;

  const GetGroupMembersParams({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class GetGroupMembers
    extends UseCase<List<GroupMemberEntity>, GetGroupMembersParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminRead;

  final GroupsRepository repository;

  GetGroupMembers(this.repository);

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> call({
    required GetGroupMembersParams params,
  }) {
    return repository.getGroupMembers(params.groupId);
  }
}
