import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class UpdateProjectParams extends Params {
  final ProjectEntity project;
  const UpdateProjectParams({required this.project});

  @override
  List<Object?> get props => [project];
}

class UpdateProjectUseCase implements UseCase<ProjectEntity, UpdateProjectParams> {
  final ProjectsRepository repository;

  UpdateProjectUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectEntity>> call({required UpdateProjectParams params}) {
    return repository.updateProject(params.project);
  }
}
