import 'package:fpdart/fpdart.dart';
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
    implements UseCase<TimeTrackingConfigEntity, SaveTimeTrackingConfigParams> {
  final TimeTrackingRepository repository;

  const SaveTimeTrackingConfig(this.repository);

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> call({
    required SaveTimeTrackingConfigParams params,
  }) {
    return repository.saveTimeTrackingConfig(params.config);
  }
}
