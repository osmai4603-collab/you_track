import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/project_entity.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/project_member_entity.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/project_template_entity.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/subsystem_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, List<ProjectTemplateEntity>>> getProjectTemplates();
  Future<Either<Failure, ProjectEntity>> getProjectById(String id);
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project);
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project);
  Future<Either<Failure, Unit>> updateProjectStartingNumber(
      String projectId, int startingNumber);
  Future<Either<Failure, Unit>> updateProjectFavorite(
      String projectId, bool isFavorite);
  Future<Either<Failure, Unit>> archiveProject(String id);
  Future<Either<Failure, Unit>> deleteProject(String id);
  Future<Either<Failure, List<ProjectMemberEntity>>> getProjectMembers(String projectId);
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(ProjectMemberEntity member);
  Future<Either<Failure, List<SubsystemEntity>>> getSubsystems(String projectId);
  Future<Either<Failure, SubsystemEntity>> getSubsystemById(String id);
  Future<Either<Failure, SubsystemEntity>> createSubsystem(SubsystemEntity subsystem);

  Future<Either<Failure, SubsystemEntity>> addSubsystem(SubsystemEntity subsystem);
}
