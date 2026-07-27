import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/work_type_entity.dart';
import '../repositories/time_tracking_repository.dart';

class AddWorkTypeParams extends Params {
  final String projectId;
  final String name;
  final String? description;

  const AddWorkTypeParams({
    required this.projectId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [projectId, name, description];
}

class AddWorkType implements UseCase<WorkTypeEntity, AddWorkTypeParams> {
  final TimeTrackingRepository repository;

  const AddWorkType(this.repository);

  @override
  Future<Either<Failure, WorkTypeEntity>> call({
    required AddWorkTypeParams params,
  }) {
    return repository.addWorkType(
      projectId: params.projectId,
      name: params.name,
      description: params.description,
    );
  }
}
