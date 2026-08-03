import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/project_entity.dart';
import '../entities/project_member_entity.dart';
import '../entities/project_template_entity.dart';
import '../entities/subsystem_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, List<ProjectTemplateEntity>>> getProjectTemplates();
  Future<Either<Failure, ProjectEntity>> getProjectById(String id);
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project);
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project);
  Future<Either<Failure, Unit>> archiveProject(String id);
  Future<Either<Failure, Unit>> deleteProject(String id);
  Future<Either<Failure, List<ProjectMemberEntity>>> getProjectMembers(String projectId);
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(ProjectMemberEntity member);
  Future<Either<Failure, List<SubsystemEntity>>> getSubsystems(String projectId);
  Future<Either<Failure, SubsystemEntity>> getSubsystemById(String id);
  Future<Either<Failure, SubsystemEntity>> createSubsystem(SubsystemEntity subsystem);

  Future<Either<Failure, SubsystemEntity>> addSubsystem(SubsystemEntity subsystem);
}
