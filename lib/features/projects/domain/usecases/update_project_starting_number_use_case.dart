import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/projects_repository.dart';

class UpdateProjectStartingNumberParams extends Params {
  final String projectId;
  final int startingNumber;
  const UpdateProjectStartingNumberParams({
    required this.projectId,
    required this.startingNumber,
  });

  @override
  List<Object?> get props => [projectId, startingNumber];
}

class UpdateProjectStartingNumberUseCase
    extends UseCase<Unit, UpdateProjectStartingNumberParams> {
  final ProjectsRepository repository;

  UpdateProjectStartingNumberUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  Future<Either<Failure, Unit>> call({
    required UpdateProjectStartingNumberParams params,
  }) {
    return repository.updateProjectStartingNumber(
      params.projectId,
      params.startingNumber,
    );
  }
}