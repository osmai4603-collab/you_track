import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/time_tracking_repository.dart';

class DeleteWorkTypeParams extends Params {
  final String workTypeId;
  final String? projectId;
  const DeleteWorkTypeParams({required this.workTypeId, this.projectId});

  @override
  List<Object?> get props => [workTypeId, projectId];
}

class DeleteWorkType extends UseCase<void, DeleteWorkTypeParams> {
  final TimeTrackingRepository repository;

  const DeleteWorkType(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  String? getProjectId(DeleteWorkTypeParams params) => params.projectId;

  @override
  Future<Either<Failure, void>> call({required DeleteWorkTypeParams params}) {
    return repository.deleteWorkType(params.workTypeId);
  }
}
