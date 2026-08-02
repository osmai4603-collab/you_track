import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class GetIntegrationsUseCase
    extends UseCasePermission<List<VcsIntegrationEntity>, GetIntegrationsParams> {
  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  final VersionControlRepository repository;

  GetIntegrationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VcsIntegrationEntity>>> execute(
      {required GetIntegrationsParams params}) {
    return repository.getIntegrations(params.projectId);
  }
}

class GetIntegrationsParams extends Params {
  final String projectId;

  const GetIntegrationsParams(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
