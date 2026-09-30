import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/unit.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/project_entity.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/project_member_entity.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/project_template_entity.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/subsystem_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/projects_repository.dart';
import 'package:youtrack_api/src/api/projects_api.dart';
import 'package:youtrack_api/src/models/project_model.dart';
import 'package:youtrack_api/src/models/project_member_model.dart';
import 'package:youtrack_api/src/models/user_model.dart';
import 'package:youtrack_api/src/network/network_error.dart';
import 'package:youtrack_frontend/features/users/domain/entities/user_entity.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsApi _api;

  ProjectsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(
    ProjectMemberEntity member,
  ) {
    // TODO: implement addProjectMember
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SubsystemEntity>> addSubsystem(
    SubsystemEntity subsystem,
  ) {
    // TODO: implement addSubsystem
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> archiveProject(String id) {
    // TODO: implement archiveProject
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject(
    ProjectEntity project,
  ) async {
    final model = ProjectModel(
      id: project.id,
      name: project.name,
      shortName: project.shortName,
      description: project.description,
      iconUrl: project.iconUrl,
      leaderId: project.leaderId,
      pinned: false,
      teamId: project.teamId,
      organizationId: project.organizationId,
      creationTime: project.creationTime,
      archived: project.archived,
      hasArticles: project.hasArticles,
      isDemo: project.isDemo,
      issuesUrl: project.issuesUrl,
      projectTypeId: project.projectTypeId,
      restricted: project.restricted,
      template: project.template,
    );
    final result = await _api.createProject(model);
    if (result.isSuccess) {
      return Right(_toEntity(result.data));
    }
    return Left(_toFailure(result.error));
  }

  @override
  Future<Either<Failure, SubsystemEntity>> createSubsystem(
    SubsystemEntity subsystem,
  ) {
    // TODO: implement createSubsystem
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(String id) {
    // TODO: implement deleteProject
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById(String id) async {
    final result = await _api.getProjectByID(id);
    if (result.isSuccess) {
      return Right(_toEntity(result.data));
    }
    return Left(_toFailure(result.error));
  }

  @override
  Future<Either<Failure, List<ProjectMemberEntity>>> getProjectMembers(
    String projectId,
  ) async {
    final result = await _api.getMembers(projectId);
    if (result.isSuccess) {
      return Right(result.data.map(_toMemberEntity).toList());
    }
    return Left(_toFailure(result.error));
  }

  @override
  Future<Either<Failure, List<ProjectTemplateEntity>>> getProjectTemplates() {
    // TODO: implement getProjectTemplates
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    // `/projects/me` already resolves visibility for the current identity on
    // the server, so no client-side permission filtering is applied here.
    final result = await _api.getProjects();
    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }

    return Right(result.data.map(_toEntity).toList(growable: false));
  }

  ProjectEntity _toEntity(ProjectModel model) {
    return ProjectEntity(
      id: model.id,
      name: model.name,
      shortName: model.shortName,
      description: model.description,
      iconUrl: model.iconUrl,
      issuesUrl: model.issuesUrl,
      leaderId: model.leaderId,
      teamId: model.teamId,
      organizationId: model.organizationId,
      projectTypeId: model.projectTypeId,
      creationTime: model.creationTime,
      pinned: model.pinned,
      archived: model.archived,
      template: model.template,
      restricted: model.restricted,
      hasArticles: model.hasArticles,
      isDemo: model.isDemo,
    );
  }

  @override
  Future<Either<Failure, SubsystemEntity>> getSubsystemById(String id) {
    // TODO: implement getSubsystemById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SubsystemEntity>>> getSubsystems(
    String projectId,
  ) {
    // TODO: implement getSubsystems
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project) {
    // TODO: implement updateProject
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateProjectFavorite(
    String projectId,
    bool isFavorite,
  ) async {
    final result = await _api.setFavorite(projectId, favorite: isFavorite);
    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }

    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateProjectStartingNumber(
    String projectId,
    int startingNumber,
  ) {
    // TODO: implement updateProjectStartingNumber
    throw UnimplementedError();
  }
}

Failure _toFailure(ApiError error) {
  return switch (error) {
    NetworkError() => const NetworkFailure(),
    TimeoutError() => const NetworkFailure(message: 'انتهت مهلة الاتصال'),
    AuthError(:final message) => PermissionDeniedFailure(message),
    PermissionError(:final message) => PermissionDeniedFailure(message),
    ServerError(:final code, :final message) => ServerFailure(
      message.isEmpty ? 'خطأ من الخادم ($code)' : message,
    ),
    ValidationError(:final message) => ValidationFailure(message),
    ResourceError(:final message) => ValidationFailure(message),
    FeatureError(:final message) => ValidationFailure(message),
    UnknownError(:final error) => ServerFailure(error.toString()),
  };
}

ProjectMemberEntity _toMemberEntity(ProjectMemberModel model) {
  return ProjectMemberEntity(
    id: model.id,
    projectId: model.projectId,
    roles: model.roles,
    isOwner: model.isOwner,
    userId: model.userId,
    userData: model.userData == null ? null : _toUserEntity(model.userData!),
  );
}

UserEntity _toUserEntity(UserModel model) {
  return UserEntity(
    id: model.id,
    fullName: model.fullName,
    username: model.username,
    email: model.email,
    avatarUrl: model.avatarUrl,
    createdAt: model.createdAt,
    isBanned: model.isBanned,
    groups: model.groups,
    projects: model.projects,
    initials: model.initials,
  );
}
