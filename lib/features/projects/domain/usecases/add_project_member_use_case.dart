import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/project_member_entity.dart';
import '../repositories/projects_repository.dart';

class AddProjectMemberParams extends Params {
  final ProjectMemberEntity member;
  const AddProjectMemberParams({required this.member});

  @override
  List<Object?> get props => [member];
}

class AddProjectMemberUseCase implements UseCase<ProjectMemberEntity, AddProjectMemberParams> {
  final ProjectsRepository repository;

  AddProjectMemberUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectMemberEntity>> call({required AddProjectMemberParams params}) {
    return repository.addProjectMember(params.member);
  }
}
