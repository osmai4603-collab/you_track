import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class UpdateFieldAccessControlParams extends Params {
  final String fieldId;
  final Map<String, dynamic> accessControl;

  const UpdateFieldAccessControlParams({
    required this.fieldId,
    required this.accessControl,
  });

  @override
  List<Object?> get props => [fieldId, accessControl];
}

class UpdateFieldAccessControlUseCase
    implements UseCase<CustomFieldEntity, UpdateFieldAccessControlParams> {
  final CustomFieldsRepository repository;

  UpdateFieldAccessControlUseCase(this.repository);

  @override
  Future<Either<Failure, CustomFieldEntity>> call({
    required UpdateFieldAccessControlParams params,
  }) {
    return repository.updateAccessControl(
      fieldId: params.fieldId,
      accessControl: params.accessControl,
    );
  }
}
