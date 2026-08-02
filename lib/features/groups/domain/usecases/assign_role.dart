import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_role_assignment_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class AssignRoleParams extends Params {
  final String groupId;
  final String roleName;
  final String? projectId;

  const AssignRoleParams({
    required this.groupId,
    required this.roleName,
    this.projectId,
  });

  @override
  List<Object?> get props => [groupId, roleName, projectId];
}

class AssignRole extends UseCasePermission<GroupRoleAssignmentEntity, AssignRoleParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  final GroupsRepository repository;

  AssignRole(this.repository);

  @override
  Future<Either<Failure, GroupRoleAssignmentEntity>> execute({required AssignRoleParams params}) {
    return repository.assignRole(
      GroupRoleAssignmentEntity(
        id: '',
        groupId: params.groupId,
        roleName: params.roleName,
        projectId: params.projectId,
      ),
    );
  }
}
