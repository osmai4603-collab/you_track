import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import '../repositories/tags_repository.dart';

class GetProjectGroups
    extends UseCase<List<GroupEntity>, GetProjectGroupsParams> {
  final TagsRepository repository;

  GetProjectGroups(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetProjectGroupsParams params) => params.projectId;

  @override
  Future<Either<Failure, List<GroupEntity>>> call({
    required GetProjectGroupsParams params,
  }) {
    return repository.getProjectGroups(projectId: params.projectId);
  }
}

class GetProjectGroupsParams extends Params {
  final String projectId;

  const GetProjectGroupsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
