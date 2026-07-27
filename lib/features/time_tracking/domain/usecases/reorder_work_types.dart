import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/time_tracking_repository.dart';

class ReorderWorkTypesParams extends Params {
  final List<String> orderedIds;
  const ReorderWorkTypesParams({required this.orderedIds});

  @override
  List<Object?> get props => [orderedIds];
}

class ReorderWorkTypes implements UseCase<void, ReorderWorkTypesParams> {
  final TimeTrackingRepository repository;

  const ReorderWorkTypes(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required ReorderWorkTypesParams params,
  }) {
    return repository.reorderWorkTypes(params.orderedIds);
  }
}
