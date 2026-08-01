import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/permission_guard_mixin.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class CreateProjectParams extends Params {
  final ProjectEntity project;
  const CreateProjectParams({required this.project});

  @override
  List<Object?> get props => [project];
}

class CreateProjectUseCase extends UseCasePermission<ProjectEntity, CreateProjectParams>
    with PermissionGuardMixin<ProjectEntity, CreateProjectParams> {
  final ProjectsRepository repository;

  CreateProjectUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectCreateProject;

  @override
  Future<Either<Failure, ProjectEntity>> call({required CreateProjectParams params}) {
    return runWithPermissionCheck(
      action: () async => repository.createProject(params.project),
    );
  }
}
