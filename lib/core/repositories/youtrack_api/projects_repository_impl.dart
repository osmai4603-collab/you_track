import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/project_template_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_member_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_template_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/projects_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'api_failure_mapper.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsApi _api;

  ProjectsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, ProjectMemberEntity>> addProjectMember(
    ProjectMemberEntity member,
  ) async {
    final result = await _api.addMember(
      member.projectId,
      userID: member.userId,
      roles: member.roles,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_toMemberEntity(result.data));
  }

  @override
  Future<Either<Failure, SubsystemEntity>> addSubsystem(
    SubsystemEntity subsystem,
  ) async {
    final result = await _api.addSubsystem(
      subsystem.projectId,
      _subsystemToJson(subsystem),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_subsystemFromJson(result.data));
  }

  @override
  Future<Either<Failure, Unit>> archiveProject(String id) async {
    final result = await _api.archiveProject(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(unit);
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
      //iconUrl: project.iconUrl,
      ownerId: project.ownerId,
      pinned: false,
      //teamId: project.teamId,
      organizationId: '',
      createdAt: project.createdAt.millisecondsSinceEpoch,
      isArchived: project.isArchived,
      projectTypeId: project.templateType.name,
      template: false,
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
  ) async {
    final result = await _api.createSubsystem(
      subsystem.projectId,
      _subsystemToJson(subsystem),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_subsystemFromJson(result.data));
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(String id) async {
    final result = await _api.deleteProject(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(unit);
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
  Future<Either<Failure, List<ProjectTemplateEntity>>>
  getProjectTemplates() async {
    final result = await _api.getProjectTemplates();
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_templateFromJson).toList(growable: false));
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

  Future<Either<Failure, ProjectEntity>> _updateProject(
    ProjectEntity project,
  ) async {
    final result = await _api.updateProject(
      project.id,
      ProjectModel(
        id: project.id,
        name: project.name,
        shortName: project.shortName,
        description: project.description,
        ownerId: project.ownerId,
        createdAt: project.createdAt.millisecondsSinceEpoch,
        isArchived: project.isArchived,
        projectTypeId: project.templateType.name,
        pinned: project.isFavorite,
      ),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_toEntity(result.data));
  }

  Future<Either<Failure, SubsystemEntity>> _getSubsystemById(String id) async {
    final result = await _api.getSubsystemByID(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_subsystemFromJson(result.data));
  }

  ProjectEntity _toEntity(ProjectModel model) {
    return ProjectEntity(
      id: model.id,
      name: model.name,
      shortName: model.shortName,
      templateType: _templateType(model.projectTypeId),
      description: model.description,
      ownerId: model.ownerId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(model.createdAt),

      // iconUrl: model.iconUrl,
      // issuesUrl: model.issuesUrl,
      // leaderId: model.ownerId,
      // teamId: model.teamId,
      // organizationId: model.organizationId,
      // projectTypeId: model.projectTypeId,
      // creationTime: model.createdAt,
      // pinned: model.pinned,
      // archived: model.isArchived,
      // template: model.template,
      // restricted: model.restricted,
      // hasArticles: model.hasArticles,
      // isDemo: model.isDemo,
    );
  }

  static ProjectTemplateType _templateType(String name) {
    for (final template in ProjectTemplateType.values) {
      if (template.name == name) return template;
    }
    return ProjectTemplateType.defaultTemplate;
  }

  @override
  Future<Either<Failure, SubsystemEntity>> getSubsystemById(String id) {
    return _getSubsystemById(id);
  }

  @override
  Future<Either<Failure, List<SubsystemEntity>>> getSubsystems(
    String projectId,
  ) async {
    final result = await _api.getSubsystems(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_subsystemFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project) {
    return _updateProject(project);
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
  ) async {
    final result = await _api.setStartingNumber(
      projectId,
      startingNumber: startingNumber,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(unit);
  }
}

SubsystemEntity _subsystemFromJson(JsonObject json) => SubsystemEntity(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] ?? '').toString(),
  projectId: (json['projectId'] ?? json['project_id'] ?? '').toString(),
  ownerId: (json['ownerId'] ?? json['owner_id'] ?? '').toString(),
  color: int.tryParse((json['color'] ?? 0).toString()) ?? 0,
  firstLetter: (json['firstLetter'] ?? json['first_letter'] ?? '').toString(),
);

JsonObject _subsystemToJson(SubsystemEntity subsystem) => {
  'id': subsystem.id,
  'name': subsystem.name,
  'projectId': subsystem.projectId,
  'ownerId': subsystem.ownerId,
  'color': subsystem.color,
  'firstLetter': subsystem.firstLetter,
};

ProjectTemplateEntity _templateFromJson(JsonObject json) =>
    ProjectTemplateEntity(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      iconKey: (json['iconKey'] ?? json['icon_key'] ?? '').toString(),
      defaultFields: json['defaultFields'] is Map
          ? (json['defaultFields'] as Map).map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const {},
    );

Failure _toFailure(ApiError error) {
  return switch (error) {
    NetworkError() => const NetworkFailure(),
    TimeoutError() => const NetworkFailure('انتهت مهلة الاتصال'),
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
