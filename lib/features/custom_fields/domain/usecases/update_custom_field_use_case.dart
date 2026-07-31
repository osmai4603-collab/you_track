import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/custom_field_type_enum.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class UpdateCustomFieldParams extends Params {
  final String fieldId;
  final String? name;
  final CustomFieldEnumType? fieldType;
  final String? defaultValue;
  final String? emptyValue;
  final bool? canBeEmpty;
  final String? valueMode;
  final List<String>? aliases;

  const UpdateCustomFieldParams({
    required this.fieldId,
    this.name,
    this.fieldType,
    this.defaultValue,
    this.emptyValue,
    this.canBeEmpty,
    this.valueMode,
    this.aliases,
  });

  @override
  List<Object?> get props =>
      [fieldId, name, fieldType, defaultValue, emptyValue, canBeEmpty, valueMode, aliases];
}

class UpdateCustomFieldUseCase
    implements UseCase<CustomFieldEntity, UpdateCustomFieldParams> {
  final CustomFieldsRepository repository;

  UpdateCustomFieldUseCase(this.repository);

  @override
  Future<Either<Failure, CustomFieldEntity>> call({
    required UpdateCustomFieldParams params,
  }) {
    return repository.updateField(
      fieldId: params.fieldId,
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
