import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/permission_guard_mixin.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/projects_repository.dart';

class ArchiveProjectParams extends Params {
  final String id;
  const ArchiveProjectParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class ArchiveProjectUseCase extends UseCasePermission<Unit, ArchiveProjectParams>
    with PermissionGuardMixin<Unit, ArchiveProjectParams> {
  final ProjectsRepository repository;

  ArchiveProjectUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectUpdateProject;

  @override
  Future<Either<Failure, Unit>> call({required ArchiveProjectParams params}) {
    return runWithPermissionCheck(
      action: () async => repository.archiveProject(params.id),
    );
  }
}
