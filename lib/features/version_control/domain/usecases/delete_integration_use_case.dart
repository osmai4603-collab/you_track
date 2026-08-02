import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class DeleteIntegrationUseCase extends UseCasePermission<void, DeleteIntegrationParams> {
  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  final VersionControlRepository repository;

  DeleteIntegrationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(
      {required DeleteIntegrationParams params}) {
    return repository.deleteIntegration(params.integrationId);
  }
}

class DeleteIntegrationParams extends Params {
  final String integrationId;

  const DeleteIntegrationParams(this.integrationId);

  @override
  List<Object?> get props => [integrationId];
}
