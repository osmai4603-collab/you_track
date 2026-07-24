import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/projects_repository.dart';

class DeleteProjectParams extends Params {
  final String id;
  const DeleteProjectParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteProjectUseCase implements UseCase<Unit, DeleteProjectParams> {
  final ProjectsRepository repository;

  DeleteProjectUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required DeleteProjectParams params}) {
    return repository.deleteProject(params.id);
  }
}
