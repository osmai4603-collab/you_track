import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/work_type_entity.dart';
import '../repositories/time_tracking_repository.dart';

class GetWorkTypesParams extends Params {
  final String projectId;
  const GetWorkTypesParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetWorkTypes
    implements UseCase<List<WorkTypeEntity>, GetWorkTypesParams> {
  final TimeTrackingRepository repository;

  const GetWorkTypes(this.repository);

  @override
  Future<Either<Failure, List<WorkTypeEntity>>> call({
    required GetWorkTypesParams params,
  }) {
    return repository.getWorkTypes(params.projectId);
  }
}
