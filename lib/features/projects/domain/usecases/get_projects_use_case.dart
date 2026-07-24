import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase implements UseCase<List<ProjectEntity>, NoParams> {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProjectEntity>>> call({required NoParams params}) {
    return repository.getProjects();
  }
}
