import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/custom_field_type_enum.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class AddCustomFieldParams extends Params {
  final String projectId;
  final String name;
  final CustomFieldTypeEnum fieldType;
  final String? defaultValue;

  const AddCustomFieldParams({
    required this.projectId,
    required this.name,
    required this.fieldType,
    this.defaultValue,
  });

  @override
  List<Object?> get props => [projectId, name, fieldType, defaultValue];
}

class AddCustomFieldUseCase
    implements UseCase<CustomFieldEntity, AddCustomFieldParams> {
  final CustomFieldsRepository repository;

  AddCustomFieldUseCase(this.repository);

  @override
  Future<Either<Failure, CustomFieldEntity>> call({
    required AddCustomFieldParams params,
  }) {
    return repository.addField(
      projectId: params.projectId,
      name: params.name,
      fieldType: params.fieldType,
      defaultValue: params.defaultValue,
    );
  }
}
