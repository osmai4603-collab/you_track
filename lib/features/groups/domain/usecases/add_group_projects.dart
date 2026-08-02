import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_project_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class AddGroupProjectsParams extends Params {
  final String groupId;
  final List<String> projectIds;

  const AddGroupProjectsParams({
    required this.groupId,
    required this.projectIds,
  });

  @override
  List<Object?> get props => [groupId, projectIds];
}

class AddGroupProjects
    extends UseCasePermission<List<GroupProjectEntity>, AddGroupProjectsParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  final GroupsRepository repository;

  AddGroupProjects(this.repository);

  @override
  Future<Either<Failure, List<GroupProjectEntity>>> call({
    required AddGroupProjectsParams params,
  }) {
    return repository.addGroupProjects(params.groupId, params.projectIds);
  }
}
