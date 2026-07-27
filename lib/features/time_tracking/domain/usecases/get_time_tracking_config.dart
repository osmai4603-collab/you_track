import 'package:fpdart/fpdart.dart';
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
    implements UseCase<TimeTrackingConfigEntity, GetTimeTrackingConfigParams> {
  final TimeTrackingRepository repository;

  const GetTimeTrackingConfig(this.repository);

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> call({
    required GetTimeTrackingConfigParams params,
  }) {
    return repository.getTimeTrackingConfig(params.projectId);
  }
}
