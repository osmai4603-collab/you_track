import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/projects_repository.dart';

class DeleteProjectParams extends Params {
  final String id;
  const DeleteProjectParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteProjectUseCase extends UseCase<Unit, DeleteProjectParams> {
  final ProjectsRepository repository;

  DeleteProjectUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectDeleteProject;

  @override
  Future<Either<Failure, Unit>> call({required DeleteProjectParams params}) {
    return repository.deleteProject(params.id);
  }
}
