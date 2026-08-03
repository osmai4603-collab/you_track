import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/time_tracking_config_entity.dart';
import '../repositories/time_tracking_repository.dart';

class GetTimeTrackingConfigParams extends Params {
  final String projectId;
  const GetTimeTrackingConfigParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetTimeTrackingConfig
    extends UseCase<TimeTrackingConfigEntity, GetTimeTrackingConfigParams> {
  final TimeTrackingRepository repository;

  const GetTimeTrackingConfig(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetTimeTrackingConfigParams params) => params.projectId;

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> call({
    required GetTimeTrackingConfigParams params,
  }) {
    return repository.getTimeTrackingConfig(params.projectId);
  }
}
