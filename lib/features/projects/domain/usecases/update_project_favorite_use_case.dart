import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/projects_repository.dart';

class UpdateProjectFavoriteParams extends Params {
  final String projectId;
  final bool isFavorite;
  const UpdateProjectFavoriteParams({
    required this.projectId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [projectId, isFavorite];
}

class UpdateProjectFavoriteUseCase
    extends UseCase<Unit, UpdateProjectFavoriteParams> {
  final ProjectsRepository repository;

  UpdateProjectFavoriteUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  Future<Either<Failure, Unit>> call({
    required UpdateProjectFavoriteParams params,
  }) {
    return repository.updateProjectFavorite(params.projectId, params.isFavorite);
  }
}