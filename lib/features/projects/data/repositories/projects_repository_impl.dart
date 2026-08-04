import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_member_entity.dart';
import '../../domain/entities/project_template_entity.dart';
import '../../domain/entities/subsystem_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_data_source.dart';
import '../datasources/projects_remote_data_source.dart';
import '../models/project_model.dart';
import '../models/project_member_model.dart';
import '../models/subsystem_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource remoteDataSource;
  final ProjectsLocalDataSource localDataSource;

  ProjectsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      final project = await remoteDataSource.getProjectById(id);
      return Right(project);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project) async {
    try {
      final model = ProjectModel.fromEntity(project);
      final created = await remoteDataSource.createProject(model);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project) async {
    try {
      final model = ProjectModel.fromEntity(project);
      final updated = await remoteDataSource.updateProject(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProjectStartingNumber(
    String projectId,
    int startingNumber,
  ) async {
    try {
      await remoteDataSource.updateStartingNumber(projectId, startingNumber);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProjectFavorite(
    String projectId,
    bool isFavorite,
  ) async {
    try {
      await remoteDataSource.updateFavorite(projectId, isFavorite);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> archiveProject(String id) async {
    try {
      await remoteDataSource.archiveProject(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(String id) async {
    try {
      await remoteDataSource.deleteProject(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectMemberEntity>>> getProjectMembers(String projectId) async {
    try {
      final members = await remoteDataSource.getProjectMembers(projectId);
      return Right(members);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(ProjectMemberEntity member) async {
    try {
      final model = ProjectMemberModel.fromEntity(member);
      final added = await remoteDataSource.addProjectMember(model);
      return Right(added);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubsystemEntity>>> getSubsystems(String projectId) async {
    try {
      final subsystems = await remoteDataSource.getSubsystems(projectId);
      return Right(subsystems);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubsystemEntity>> getSubsystemById(String id) async {
    try {
      final subsystem = await remoteDataSource.getSubsystemById(id);
      return Right(subsystem);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubsystemEntity>> createSubsystem(SubsystemEntity subsystem) async {
    try {
      final model = SubsystemModel.fromEntity(subsystem);
      final created = await remoteDataSource.createSubsystem(model);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, SubsystemEntity>> addSubsystem(SubsystemEntity subsystem) async {
    try {
      final model = SubsystemModel.fromEntity(subsystem);
      final added = await remoteDataSource.addSubsystem(model);
      return Right(added);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
