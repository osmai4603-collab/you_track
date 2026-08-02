import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class AddGroupMembersParams extends Params {
  final String groupId;
  final List<String> userIds;

  const AddGroupMembersParams({required this.groupId, required this.userIds});

  @override
  List<Object?> get props => [groupId, userIds];
}

class AddGroupMembers
    extends UseCasePermission<List<GroupMemberEntity>, AddGroupMembersParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  final GroupsRepository repository;

  AddGroupMembers(this.repository);

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> execute({
    required AddGroupMembersParams params,
  }) {
    return repository.addGroupMembers(params.groupId, params.userIds);
  }
}
