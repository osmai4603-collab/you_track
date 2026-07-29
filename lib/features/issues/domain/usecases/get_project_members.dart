import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import '../entities/project_member.dart';
import '../repositories/tags_repository.dart';

class GetProjectMembers implements UseCase<List<ProjectMember>, GetProjectMembersParams> {
  final TagsRepository repository;

  GetProjectMembers(this.repository);

  @override
  Future<Either<Failure, List<ProjectMember>>> call({required GetProjectMembersParams params}) {
    return repository.getProjectMembers(projectId: params.projectId);
  }
}

class GetProjectMembersParams extends Params {
  final String projectId;

  const GetProjectMembersParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
