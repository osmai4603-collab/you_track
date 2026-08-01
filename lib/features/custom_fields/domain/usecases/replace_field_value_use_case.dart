import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/custom_fields_repository.dart';

class ReplaceFieldValueUseCase
    extends UseCasePermission<void, ReplaceFieldValueParams> {
  final CustomFieldsRepository repository;

  ReplaceFieldValueUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required ReplaceFieldValueParams params,
  }) async {
    return repository.replaceFieldValue(
      fieldId: params.fieldId,
      oldValue: params.oldValue,
      newValue: params.newValue,
    );
  }
}

class ReplaceFieldValueParams extends Params {
  final String fieldId;
  final String oldValue;
  final String newValue;

  const ReplaceFieldValueParams({
    required this.fieldId,
    required this.oldValue,
    required this.newValue,
  });

  @override
  List<Object?> get props => [fieldId, oldValue, newValue];
}
