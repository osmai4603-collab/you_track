import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_member_entity.dart';
import '../../domain/entities/project_template_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_data_source.dart';
import '../models/project_model.dart';
import '../models/project_member_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsLocalDataSource localDataSource;

  ProjectsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final projects = await localDataSource.getProjects();
      return Right(projects);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectTemplateEntity>>> getProjectTemplates() async {
    try {
      final templates = await localDataSource.getProjectTemplates();
      return Right(templates);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById(String id) async {
    try {
      final project = await localDataSource.getProjectById(id);
      return Right(project);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project) async {
    try {
      final model = ProjectModel.fromEntity(project);
      final created = await localDataSource.createProject(model);
      return Right(created);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project) async {
    try {
      final model = ProjectModel.fromEntity(project);
      final updated = await localDataSource.updateProject(model);
      return Right(updated);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> archiveProject(String id) async {
    try {
      await localDataSource.archiveProject(id);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(String id) async {
    try {
      await localDataSource.deleteProject(id);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectMemberEntity>>> getProjectMembers(String projectId) async {
    try {
      final members = await localDataSource.getProjectMembers(projectId);
      return Right(members);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(ProjectMemberEntity member) async {
    try {
      final model = ProjectMemberModel.fromEntity(member);
      final added = await localDataSource.addProjectMember(model);
      return Right(added);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }
}
