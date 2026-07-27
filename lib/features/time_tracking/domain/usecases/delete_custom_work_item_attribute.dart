import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/time_tracking_repository.dart';

class DeleteCustomAttributeParams extends Params {
  final String attributeId;
  const DeleteCustomAttributeParams({required this.attributeId});

  @override
  List<Object?> get props => [attributeId];
}

class DeleteCustomAttribute implements UseCase<void, DeleteCustomAttributeParams> {
  final TimeTrackingRepository repository;

  const DeleteCustomAttribute(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required DeleteCustomAttributeParams params,
  }) {
    return repository.deleteCustomAttribute(params.attributeId);
  }
}
