import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/custom_fields_repository.dart';

class ReorderCustomFieldsParams extends Params {
  final String projectId;
  final int oldIndex;
  final int newIndex;

  const ReorderCustomFieldsParams({
    required this.projectId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [projectId, oldIndex, newIndex];
}

class ReorderCustomFieldsUseCase
    implements UseCase<void, ReorderCustomFieldsParams> {
  final CustomFieldsRepository repository;

  ReorderCustomFieldsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required ReorderCustomFieldsParams params,
  }) {
    return repository.reorderField(
      projectId: params.projectId,
      oldIndex: params.oldIndex,
      newIndex: params.newIndex,
    );
  }
}
