import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectByIdParams extends Params {
  final String id;
  const GetProjectByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetProjectByIdUseCase implements UseCase<ProjectEntity, GetProjectByIdParams> {
  final ProjectsRepository repository;

  GetProjectByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectEntity>> call({required GetProjectByIdParams params}) {
    return repository.getProjectById(params.id);
  }
}
