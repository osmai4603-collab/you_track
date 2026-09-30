import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/issues_repository.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/build.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/issue.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/issue_attachment.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/issue_filter.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/sprint.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/tag.dart';
import 'package:youtrack_frontend/core/enums/issue_state_enum.dart';
import 'package:youtrack_frontend/core/enums/issue_priority_type_enum.dart';
import 'package:youtrack_frontend/core/enums/issue_type_enum.dart';
import 'package:youtrack_api/src/api/issues_api.dart';
import 'package:youtrack_api/src/models/issue_model.dart';
import 'package:youtrack_api/src/network/network_error.dart';

class IssuesRepositoryImpl implements IssuesRepository {
  final IssuesApi _api;

  IssuesRepositoryImpl(this._api);

  @override
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter) async {
    final parameters = _toQueryParameters(filter);

    // A filter scoped to one project is served by the per-project endpoint
    // rather than by adding a project filter to the global listing. The server
    // answers a project the identity cannot read with 404 on that route, which
    // is the behaviour the project screen expects; the global route would
    // instead answer 200 with an empty list and make a permission problem look
    // like an empty project.
    final projectId = filter.projectFilter;
    final result = (projectId != null && projectId.isNotEmpty)
        ? await _api.getProjectIssues(projectId, queryParameters: parameters)
        : await _api.getIssues(queryParameters: parameters);

    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }
    return Right(_toEntities(result.data));
  }

  @override
  Future<Either<Failure, Issue>> getIssueById(String id) async {
    final result = await _api.getIssueByID(id);
    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }
    return Right(_toEntity(result.data));
  }

  @override
  Future<Either<Failure, List<Issue>>> getProjectIssues(
    String projectId, {
    IssueFilter filter = const IssueFilter(),
  }) async {
    final result = await _api.getProjectIssues(
      projectId,
      queryParameters: _toQueryParameters(filter),
    );
    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }
    return Right(_toEntities(result.data));
  }

  /// Returns an empty tag list rather than throwing.
  ///
  /// The issues screen calls this on every load, before it asks for issues, so
  /// leaving it unimplemented took down the whole screen regardless of how well
  /// `getIssues` worked. The server has no tags endpoint and the `tags` table
  /// cannot be serialized into the app's TagModel anyway, so an empty list is
  /// the honest answer: the tag filter shows no options instead of crashing.
  @override
  Future<Either<Failure, List<Tag>>> getAllTags() async {
    return const Right(<Tag>[]);
  }

  /// Emits the current issues once and closes.
  ///
  /// This is not a live stream: the server exposes no issue-change feed, so
  /// there is nothing to push updates from. The agile board only needs the
  /// initial set, and the screen re-queries when its filters change. Callers
  /// that need a refresh have to trigger it.
  @override
  Stream<Issue> streamIssues(IssueFilter filter) async* {
    final result = await getIssues(filter);
    final issues = result.fold((_) => const <Issue>[], (list) => list);
    yield* Stream<Issue>.fromIterable(issues);
  }

  // ---------------------------------------------------------------------------
  // Query mapping
  // ---------------------------------------------------------------------------

  /// Builds the query string for the issues endpoints.
  ///
  /// Unset filters are omitted rather than sent empty, so the server applies no
  /// narrowing instead of filtering on a value that cannot match.
  Map<String, dynamic> _toQueryParameters(IssueFilter filter) {
    final parameters = <String, dynamic>{};

    if (filter.searchQuery.trim().isNotEmpty) {
      parameters['search'] = filter.searchQuery.trim();
    }
    if (filter.stateFilter != null) {
      parameters['state'] = filter.stateFilter!.name;
    }
    if (filter.priorityFilter != null) {
      parameters['priority'] = filter.priorityFilter!.name;
    }
    if (filter.typeFilter != null) {
      parameters['issueType'] = filter.typeFilter!.name;
    }
    if (filter.assigneeFilter != null && filter.assigneeFilter!.isNotEmpty) {
      parameters['assignee'] = filter.assigneeFilter;
    }
    if (filter.tagFilter != null && filter.tagFilter!.isNotEmpty) {
      parameters['tag'] = filter.tagFilter;
    }
    if (filter.projectFilter != null && filter.projectFilter!.isNotEmpty) {
      parameters['projectId'] = filter.projectFilter;
    }

    parameters['sort'] = filter.sortField.name;
    parameters['ascending'] = filter.sortAscending;

    return parameters;
  }

  // ---------------------------------------------------------------------------
  // Model -> entity mapping
  // ---------------------------------------------------------------------------

  List<Issue> _toEntities(List<IssueModel> models) {
    return models.map(_toEntity).toList(growable: false);
  }

  Issue _toEntity(IssueModel model) {
    return Issue(
      id: model.id,
      projectId: model.projectId,
      issueKey: model.issueKey,
      issueNumber: model.issueNumber,
      summary: model.summary,
      description: model.description,
      state: _toState(model.state),
      priority: _toPriority(model.priority),
      issueType: _toType(model.issueType),
      assigneeId: model.assigneeId,
      assigneeAvatarUrl: model.assigneeAvatarUrl,
      // The app's entity declares reporterId as a non-nullable String, so an
      // absent value becomes '' rather than null.
      reporterId: model.reporterId ?? '',
      subsystemId: model.subsystemId,
      fixVersions: model.fixVersions,
      buildId: model.buildId,
      // The server sends these as empty, and the entity's own defaults are the
      // empty list, so they are passed straight through.
      tags: const [],
      sprints: const [],
      links: const [],
      createdAt: model.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: model.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      dueDate: model.dueDate,
      estimation: model.estimationMinutes == null
          ? null
          : Duration(minutes: model.estimationMinutes!),
      spentTime: model.spentTimeMinutes == null
          ? null
          : Duration(minutes: model.spentTimeMinutes!),
      votes: model.votes,
      watchersCount: model.watchersCount,
      attachmentsCount: model.attachmentsCount,
      commentsCount: model.commentsCount,
      isStarred: model.isStarred,
      parentId: model.parentId,
      visibility: model.visibility,
    );
  }

  // ---------------------------------------------------------------------------
  // Enum mapping
  // ---------------------------------------------------------------------------

  // The three enums do not agree on how to treat an unrecognised name: state and
  // type fall back to a default, but priority throws an ArgumentError. A single
  // row carrying a priority this build has never heard of would therefore abort
  // the whole mapping and take the issue list down with it, and the throw would
  // escape getIssues as an exception rather than arrive as a Failure the bloc can
  // render. The backend constrains the column with a CHECK, so this only fires
  // when the two sides drift, but a list screen should not be the place that
  // finds out.
  static IssueStateEnum _toState(String name) {
    try {
      return IssueStateEnum.of(name);
    } catch (_) {
      return IssueStateEnum.toDo;
    }
  }

  static IssuePriorityTypeEnum _toPriority(String name) {
    try {
      return IssuePriorityTypeEnum.of(name);
    } catch (_) {
      return IssuePriorityTypeEnum.normal;
    }
  }

  static IssueTypeEnum _toType(String name) {
    try {
      return IssueTypeEnum.of(name);
    } catch (_) {
      return IssueTypeEnum.task;
    }
  }

  // ---------------------------------------------------------------------------
  // Not yet backed by an endpoint
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, Build>> createBuild(Build build) {
    // TODO: implement createBuild
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Issue>> createIssue(Issue issue) {
    // TODO: implement createIssue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteAttachment({
    required String issueId,
    required String storagePath,
  }) {
    // TODO: implement deleteAttachment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteIssue(String issueId) {
    // TODO: implement deleteIssue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<IssueAttachment>>> getAttachments(
    String issueId,
  ) {
    // TODO: implement getAttachments
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Build>>> getBuilds(String projectId) {
    // TODO: implement getBuilds
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Sprint>>> getSprints(String projectId) {
    // TODO: implement getSprints
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Issue>> updateIssue(Issue issue) {
    // TODO: implement updateIssue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateIssueStarred(
    String issueId,
    bool isStarred,
  ) {
    // TODO: implement updateIssueStarred
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    // TODO: implement uploadAttachment
    throw UnimplementedError();
  }
}

Failure _toFailure(ApiError error) {
  return switch (error) {
    NetworkError() => const NetworkFailure(),
    TimeoutError() => const NetworkFailure(),
    AuthError(:final message) => PermissionDeniedFailure(message),
    PermissionError(:final message) => PermissionDeniedFailure(message),
    ServerError(:final code, :final message) => ServerFailure(
      message.isEmpty ? 'The server returned an error. ($code)' : message,
    ),
    ValidationError(:final message) => ValidationFailure(message),
    ResourceError(:final message) => ValidationFailure(message),
    FeatureError(:final message) => ValidationFailure(message),
    UnknownError(:final error) => ServerFailure(error.toString()),
  };
}
