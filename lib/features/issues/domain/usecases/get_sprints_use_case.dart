import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/sprint.dart';
import '../repositories/issues_repository.dart';

class GetSprintsParams extends Params {
  final String projectId;
  const GetSprintsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetSprintsUseCase extends UseCase<List<Sprint>, GetSprintsParams> {
  final IssuesRepository repository;

  GetSprintsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetSprintsParams params) => params.projectId;

  @override
  Future<Either<Failure, List<Sprint>>> call({
    required GetSprintsParams params,
  }) {
    return repository.getSprints(params.projectId);
  }
}
