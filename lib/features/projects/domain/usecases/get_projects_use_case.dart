import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase extends UseCasePermission<List<ProjectEntity>, NoParams> {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  Future<Either<Failure, List<ProjectEntity>>> execute({required NoParams params}) {
    return repository.getProjects();
  }
}
