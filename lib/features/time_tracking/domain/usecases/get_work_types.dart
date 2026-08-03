import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/work_type_entity.dart';
import '../repositories/time_tracking_repository.dart';

class GetWorkTypesParams extends Params {
  final String projectId;
  const GetWorkTypesParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetWorkTypes extends UseCase<List<WorkTypeEntity>, GetWorkTypesParams> {
  final TimeTrackingRepository repository;

  const GetWorkTypes(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetWorkTypesParams params) => params.projectId;

  @override
  Future<Either<Failure, List<WorkTypeEntity>>> call({
    required GetWorkTypesParams params,
  }) {
    return repository.getWorkTypes(params.projectId);
  }
}
