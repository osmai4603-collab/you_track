import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class DeleteIntegrationUseCase extends UseCase<void, DeleteIntegrationParams> {
  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(DeleteIntegrationParams params) => params.projectId;

  final VersionControlRepository repository;

  DeleteIntegrationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required DeleteIntegrationParams params,
  }) {
    return repository.deleteIntegration(params.integrationId);
  }
}

class DeleteIntegrationParams extends Params {
  final String integrationId;
  final String? projectId;

  const DeleteIntegrationParams(this.integrationId, {this.projectId});

  @override
  List<Object?> get props => [integrationId, projectId];
}
