import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/work_type_entity.dart';
import '../repositories/time_tracking_repository.dart';

class UpdateWorkTypeParams extends Params {
  final String workTypeId;
  final String? projectId;
  final String? name;
  final String? description;
  final bool? isActive;

  const UpdateWorkTypeParams({
    required this.workTypeId,
    this.projectId,
    this.name,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [
    workTypeId,
    projectId,
    name,
    description,
    isActive,
  ];
}

class UpdateWorkType extends UseCase<WorkTypeEntity, UpdateWorkTypeParams> {
  final TimeTrackingRepository repository;

  const UpdateWorkType(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(UpdateWorkTypeParams params) => params.projectId;

  @override
  Future<Either<Failure, WorkTypeEntity>> call({
    required UpdateWorkTypeParams params,
  }) {
    return repository.updateWorkType(
      workTypeId: params.workTypeId,
      name: params.name,
      description: params.description,
      isActive: params.isActive,
    );
  }
}
