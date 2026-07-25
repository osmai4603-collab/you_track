import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/custom_field_entity.dart';
import '../repositories/custom_fields_repository.dart';

class GetCustomFieldsParams extends Params {
  final String projectId;
  const GetCustomFieldsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetCustomFieldsUseCase
    implements UseCase<List<CustomFieldEntity>, GetCustomFieldsParams> {
  final CustomFieldsRepository repository;

  GetCustomFieldsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CustomFieldEntity>>> call({
    required GetCustomFieldsParams params,
  }) {
    return repository.getFields(params.projectId);
  }
}
