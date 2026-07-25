import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/custom_fields_repository.dart';

class DeleteCustomFieldsParams extends Params {
  final List<String> fieldIds;
  const DeleteCustomFieldsParams({required this.fieldIds});

  @override
  List<Object?> get props => [fieldIds];
}

class DeleteCustomFieldsUseCase
    implements UseCase<void, DeleteCustomFieldsParams> {
  final CustomFieldsRepository repository;

  DeleteCustomFieldsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required DeleteCustomFieldsParams params,
  }) {
    return repository.deleteFields(params.fieldIds);
  }
}
