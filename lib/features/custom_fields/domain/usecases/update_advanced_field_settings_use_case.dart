import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class UpdateAdvancedFieldSettingsParams extends Params {
  final String fieldId;
  final List<String>? visibleTo;
  final List<String>? updatableBy;
  final String? showOnlyWhen;
  final String? filterValuesBasedOn;

  const UpdateAdvancedFieldSettingsParams({
    required this.fieldId,
    this.visibleTo,
    this.updatableBy,
    this.showOnlyWhen,
    this.filterValuesBasedOn,
  });

  @override
  List<Object?> get props =>
      [fieldId, visibleTo, updatableBy, showOnlyWhen, filterValuesBasedOn];
}

class UpdateAdvancedFieldSettingsUseCase
    implements UseCase<CustomFieldEntity, UpdateAdvancedFieldSettingsParams> {
  final CustomFieldsRepository repository;

  UpdateAdvancedFieldSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, CustomFieldEntity>> call({
    required UpdateAdvancedFieldSettingsParams params,
  }) {
    return repository.updateAdvancedSettings(
      fieldId: params.fieldId,
      visibleTo: params.visibleTo,
      updatableBy: params.updatableBy,
      showOnlyWhen: params.showOnlyWhen,
      filterValuesBasedOn: params.filterValuesBasedOn,
    );
  }
}
