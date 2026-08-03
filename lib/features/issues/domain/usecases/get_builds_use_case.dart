import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/build.dart';
import '../repositories/issues_repository.dart';

class GetBuildsParams extends Params {
  final String projectId;
  const GetBuildsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetBuildsUseCase extends UseCase<List<Build>, GetBuildsParams> {
  final IssuesRepository repository;

  GetBuildsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetBuildsParams params) => params.projectId;

  @override
  Future<Either<Failure, List<Build>>> call({required GetBuildsParams params}) {
    return repository.getBuilds(params.projectId);
  }
}
