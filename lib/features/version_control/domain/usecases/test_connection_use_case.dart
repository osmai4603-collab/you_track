import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class TestConnectionUseCase
    extends UseCasePermission<VcsIntegrationEntity, TestConnectionParams> {
  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  final VersionControlRepository repository;

  TestConnectionUseCase(this.repository);

  @override
  Future<Either<Failure, VcsIntegrationEntity>> execute(
      {required TestConnectionParams params}) {
    return repository.testConnection(params.integrationId);
  }
}

class TestConnectionParams extends Params {
  final String integrationId;

  const TestConnectionParams(this.integrationId);

  @override
  List<Object?> get props => [integrationId];
}
