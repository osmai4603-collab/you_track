import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/projects_repository.dart';

class ArchiveProjectParams extends Params {
  final String id;
  const ArchiveProjectParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class ArchiveProjectUseCase implements UseCase<Unit, ArchiveProjectParams> {
  final ProjectsRepository repository;

  ArchiveProjectUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required ArchiveProjectParams params}) {
    return repository.archiveProject(params.id);
  }
}
