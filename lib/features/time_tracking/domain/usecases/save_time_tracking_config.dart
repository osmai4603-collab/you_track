import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/time_tracking_config_entity.dart';
import '../repositories/time_tracking_repository.dart';

class SaveTimeTrackingConfigParams extends Params {
  final TimeTrackingConfigEntity config;
  const SaveTimeTrackingConfigParams({required this.config});

  @override
  List<Object?> get props => [config];
}

class SaveTimeTrackingConfig
    extends UseCase<TimeTrackingConfigEntity, SaveTimeTrackingConfigParams> {
  final TimeTrackingRepository repository;

  const SaveTimeTrackingConfig(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(SaveTimeTrackingConfigParams params) =>
      params.config.projectId;

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> call({
    required SaveTimeTrackingConfigParams params,
  }) {
    return repository.saveTimeTrackingConfig(params.config);
  }
}
