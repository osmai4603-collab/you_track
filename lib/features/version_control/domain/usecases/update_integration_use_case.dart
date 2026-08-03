import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class UpdateIntegrationUseCase
    extends UseCase<VcsIntegrationEntity, UpdateIntegrationParams> {
  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(UpdateIntegrationParams params) =>
      params.integration.projectId;

  final VersionControlRepository repository;

  UpdateIntegrationUseCase(this.repository);

  @override
  Future<Either<Failure, VcsIntegrationEntity>> call({
    required UpdateIntegrationParams params,
  }) {
    return repository.updateIntegration(params.integration);
  }
}

class UpdateIntegrationParams extends Params {
  final VcsIntegrationEntity integration;

  const UpdateIntegrationParams(this.integration);

  @override
  List<Object?> get props => [integration];
}
