import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/custom_field_type_enum.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class AddCustomFieldParams extends Params {
  final String projectId;
  final String name;
  final CustomFieldEnumType fieldType;
  final String? defaultValue;
  final String? emptyValue;
  final bool canBeEmpty;
  final String valueMode;
  final List<String>? aliases;

  const AddCustomFieldParams({
    required this.projectId,
    required this.name,
    required this.fieldType,
    this.defaultValue,
    this.emptyValue,
    this.canBeEmpty = true,
    this.valueMode = 'single',
    this.aliases,
  });

  @override
  List<Object?> get props =>
      [projectId, name, fieldType, defaultValue, emptyValue, canBeEmpty, valueMode, aliases];
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
      emptyValue: params.emptyValue,
      canBeEmpty: params.canBeEmpty,
      valueMode: params.valueMode,
      aliases: params.aliases,
    );
  }
}
