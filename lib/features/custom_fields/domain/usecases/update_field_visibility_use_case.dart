import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class UpdateFieldVisibilityParams extends Params {
  final String fieldId;
  final String visibility;

  const UpdateFieldVisibilityParams({
    required this.fieldId,
    required this.visibility,
  });

  @override
  List<Object?> get props => [fieldId, visibility];
}

class UpdateFieldVisibilityUseCase
    implements UseCase<CustomFieldEntity, UpdateFieldVisibilityParams> {
  final CustomFieldsRepository repository;

  UpdateFieldVisibilityUseCase(this.repository);

  @override
  Future<Either<Failure, CustomFieldEntity>> call({
    required UpdateFieldVisibilityParams params,
  }) {
    return repository.updateVisibility(
      fieldId: params.fieldId,
      visibility: params.visibility,
    );
  }
}
