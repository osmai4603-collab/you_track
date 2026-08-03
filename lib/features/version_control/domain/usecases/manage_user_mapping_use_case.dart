import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:issues_tracking/features/version_control/domain/repositories/version_control_repository.dart';

class ManageUserMappingUseCase
    extends UseCase<List<VcsUserMappingEntity>, ManageUserMappingParams> {
  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  final VersionControlRepository repository;

  ManageUserMappingUseCase(this.repository);

  @override
  Future<Either<Failure, List<VcsUserMappingEntity>>> call({
    required ManageUserMappingParams params,
  }) async {
    if (params.deleteMappingId != null) {
      final deleteResult = await repository.deleteUserMapping(
        params.deleteMappingId!,
      );
      return deleteResult.fold(
        (failure) => Left(failure),
        (_) => repository.getUserMappings(params.integrationId),
      );
    }

    if (params.newMapping != null) {
      final createResult = await repository.createUserMapping(
        params.newMapping!,
      );
      return createResult.fold(
        (failure) => Left(failure),
        (_) => repository.getUserMappings(params.integrationId),
      );
    }

    return repository.getUserMappings(params.integrationId);
  }
}

class ManageUserMappingParams extends Params {
  final String integrationId;
  final VcsUserMappingEntity? newMapping;
  final String? deleteMappingId;

  const ManageUserMappingParams({
    required this.integrationId,
    this.newMapping,
    this.deleteMappingId,
  });

  @override
  List<Object?> get props => [integrationId, newMapping, deleteMappingId];
}
