import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_template_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectTemplatesUseCase implements UseCase<List<ProjectTemplateEntity>, NoParams> {
  final ProjectsRepository repository;

  GetProjectTemplatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProjectTemplateEntity>>> call({required NoParams params}) {
    return repository.getProjectTemplates();
  }
}
