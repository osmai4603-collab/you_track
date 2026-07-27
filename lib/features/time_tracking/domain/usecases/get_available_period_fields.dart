import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/custom_field_type_enum.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../custom_fields/domain/entities/custom_field_entity.dart';
import '../../../custom_fields/domain/repositories/custom_fields_repository.dart';

class GetAvailablePeriodFieldsParams extends Params {
  final String projectId;
  const GetAvailablePeriodFieldsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetAvailablePeriodFields
    implements UseCase<List<CustomFieldEntity>, GetAvailablePeriodFieldsParams> {
  final CustomFieldsRepository repository;

  const GetAvailablePeriodFields(this.repository);

  @override
  Future<Either<Failure, List<CustomFieldEntity>>> call({
    required GetAvailablePeriodFieldsParams params,
  }) async {
    final result = await repository.getFields(params.projectId);
    return result.fold(
      (failure) => Left(failure),
      (fields) => Right(
        fields.where((f) => f.fieldType == CustomFieldEnumType.period).toList(),
      ),
    );
  }
}
