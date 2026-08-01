import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class CreateIntegrationUseCase
    extends UseCasePermission<VcsIntegrationEntity, CreateIntegrationParams> {
  final VersionControlRepository repository;

  CreateIntegrationUseCase(this.repository);

  @override
  Future<Either<Failure, VcsIntegrationEntity>> call(
      {required CreateIntegrationParams params}) {
    return repository.createIntegration(params.integration);
  }
}

class CreateIntegrationParams extends Params {
  final VcsIntegrationEntity integration;

  const CreateIntegrationParams(this.integration);

  @override
  List<Object?> get props => [integration];
}
