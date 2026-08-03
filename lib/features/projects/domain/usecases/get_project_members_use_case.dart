import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_member_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectMembersParams extends Params {
  final String projectId;
  const GetProjectMembersParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetProjectMembersUseCase
    extends UseCase<List<ProjectMemberEntity>, GetProjectMembersParams> {
  final ProjectsRepository repository;

  GetProjectMembersUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetProjectMembersParams params) => params.projectId;

  @override
  Future<Either<Failure, List<ProjectMemberEntity>>> call({
    required GetProjectMembersParams params,
  }) {
    return repository.getProjectMembers(params.projectId);
  }
}
