import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/time_tracking_repository.dart';

class DeleteWorkTypeParams extends Params {
  final String workTypeId;
  const DeleteWorkTypeParams({required this.workTypeId});

  @override
  List<Object?> get props => [workTypeId];
}

class DeleteWorkType implements UseCase<void, DeleteWorkTypeParams> {
  final TimeTrackingRepository repository;

  const DeleteWorkType(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required DeleteWorkTypeParams params,
  }) {
    return repository.deleteWorkType(params.workTypeId);
  }
}
