import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_work_item_attribute_entity.dart';
import '../repositories/time_tracking_repository.dart';

class AddCustomAttributeParams extends Params {
  final String projectId;
  final String name;
  final String fieldType;
  final bool isRequired;
  final List<String>? options;

  const AddCustomAttributeParams({
    required this.projectId,
    required this.name,
    required this.fieldType,
    this.isRequired = false,
    this.options,
  });

  @override
  List<Object?> get props => [projectId, name, fieldType, isRequired, options];
}

class AddCustomAttribute
    implements UseCase<CustomWorkItemAttributeEntity, AddCustomAttributeParams> {
  final TimeTrackingRepository repository;

  const AddCustomAttribute(this.repository);

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> call({
    required AddCustomAttributeParams params,
  }) {
    return repository.addCustomAttribute(
      projectId: params.projectId,
      name: params.name,
      fieldType: params.fieldType,
      isRequired: params.isRequired,
      options: params.options,
    );
  }
}
