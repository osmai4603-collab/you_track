import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase extends UseCase<List<ProjectEntity>, NoParams> {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  Future<Either<Failure, List<ProjectEntity>>> call({
    NoParams params = const NoParams(),
  }) async {
    return await repository.getProjects().then(
      (result) => result.fold((failure) => Left(failure), (projects) {
        final session = get_it<UserSession>();
        final filteredProjects = projects.where((project) {
          return session.hasPermission(
            requiredPermission,
            projectId: project.id,
          );
        }).toList();
        return Right(filteredProjects);
      }),
    );
  }
}
