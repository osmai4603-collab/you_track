import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_work_item_attribute_entity.dart';
import '../repositories/time_tracking_repository.dart';

class UpdateCustomAttributeParams extends Params {
  final String attributeId;
  final String? name;
  final String? fieldType;
  final bool? isRequired;
  final List<String>? options;

  const UpdateCustomAttributeParams({
    required this.attributeId,
    this.name,
    this.fieldType,
    this.isRequired,
    this.options,
  });

  @override
  List<Object?> get props => [attributeId, name, fieldType, isRequired, options];
}

class UpdateCustomAttribute
    implements UseCase<CustomWorkItemAttributeEntity, UpdateCustomAttributeParams> {
  final TimeTrackingRepository repository;

  const UpdateCustomAttribute(this.repository);

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> call({
    required UpdateCustomAttributeParams params,
  }) {
    return repository.updateCustomAttribute(
      attributeId: params.attributeId,
      name: params.name,
      fieldType: params.fieldType,
      isRequired: params.isRequired,
      options: params.options,
    );
  }
}
