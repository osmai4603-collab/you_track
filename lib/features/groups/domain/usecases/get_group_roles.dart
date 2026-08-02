import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class GetGroupRolesParams extends Params {
  final String groupId;

  const GetGroupRolesParams({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class GetGroupRoles extends UseCasePermission<List<GroupRoleAssignmentEntity>, GetGroupRolesParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminRead;

  final GroupsRepository repository;

  GetGroupRoles(this.repository);

  @override
  Future<Either<Failure, List<GroupRoleAssignmentEntity>>> execute({required GetGroupRolesParams params}) {
    return repository.getGroupRoles(params.groupId);
  }
}
