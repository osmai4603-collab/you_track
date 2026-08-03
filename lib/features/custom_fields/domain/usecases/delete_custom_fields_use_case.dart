import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/custom_fields_repository.dart';

class DeleteCustomFieldsParams extends Params {
  final List<String> fieldIds;
  final String? projectId;
  const DeleteCustomFieldsParams({required this.fieldIds, this.projectId});

  @override
  List<Object?> get props => [fieldIds, projectId];
}

class DeleteCustomFieldsUseCase
    extends UseCase<void, DeleteCustomFieldsParams> {
  final CustomFieldsRepository repository;

  DeleteCustomFieldsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(DeleteCustomFieldsParams params) => params.projectId;

  @override
  Future<Either<Failure, void>> call({
    required DeleteCustomFieldsParams params,
  }) {
    return repository.deleteFields(params.fieldIds);
  }
}
