import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class CreateProjectParams extends Params {
  final ProjectEntity project;
  const CreateProjectParams({required this.project});

  @override
  List<Object?> get props => [project];
}

class CreateProjectUseCase implements UseCase<ProjectEntity, CreateProjectParams> {
  final ProjectsRepository repository;

  CreateProjectUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectEntity>> call({required CreateProjectParams params}) {
    return repository.createProject(params.project);
  }
}
