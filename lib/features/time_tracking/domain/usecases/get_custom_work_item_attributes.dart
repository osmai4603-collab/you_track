import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_work_item_attribute_entity.dart';
import '../repositories/time_tracking_repository.dart';

class GetCustomAttributesParams extends Params {
  final String projectId;
  const GetCustomAttributesParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetCustomAttributes
    implements UseCase<List<CustomWorkItemAttributeEntity>, GetCustomAttributesParams> {
  final TimeTrackingRepository repository;

  const GetCustomAttributes(this.repository);

  @override
  Future<Either<Failure, List<CustomWorkItemAttributeEntity>>> call({
    required GetCustomAttributesParams params,
  }) {
    return repository.getCustomAttributes(params.projectId);
  }
}
