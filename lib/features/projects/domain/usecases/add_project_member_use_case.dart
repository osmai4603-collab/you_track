import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_member_entity.dart';
import '../repositories/projects_repository.dart';

class AddProjectMemberParams extends Params {
  final ProjectMemberEntity member;
  const AddProjectMemberParams({required this.member});

  @override
  List<Object?> get props => [member];
}

class AddProjectMemberUseCase
    extends UseCase<ProjectMemberEntity, AddProjectMemberParams> {
  final ProjectsRepository repository;

  AddProjectMemberUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(AddProjectMemberParams params) =>
      params.member.projectId;

  @override
  Future<Either<Failure, ProjectMemberEntity>> call({
    required AddProjectMemberParams params,
  }) {
    return repository.addProjectMember(params.member);
  }
}
