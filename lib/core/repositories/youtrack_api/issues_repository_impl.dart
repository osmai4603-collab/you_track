import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/repositories/abstractions/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/entities/build.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_link_type.dart';
import 'package:youtrack_api/youtrack_api.dart';

class IssuesRepositoryImpl implements IssuesRepository {
  final IssuesApi _api;
  final TagsApi _tagsApi;

  IssuesRepositoryImpl(this._api, this._tagsApi);

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

  @override
  Future<Either<Failure, List<Tag>>> getAllTags() async {
    final result = await _tagsApi.getTags();
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(result.data.map(_tagFromJson).toList(growable: false));
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
      tags: model.tags.map(_tagFromJson).toList(growable: false),
      sprints: model.sprints.map(_sprintFromJson).toList(growable: false),
      links: model.issueLinks.map(_issueLinkFromJson).toList(growable: false),
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
  Future<Either<Failure, Build>> createBuild(Build build) async {
    final result = await _api.createBuild(build.projectId ?? '', {
      'id': build.id,
      'name': build.name,
      'date': build.date?.toIso8601String(),
    });
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(_buildFromJson(result.data));
  }

  @override
  Future<Either<Failure, Issue>> createIssue(Issue issue) async {
    final result = await _api.createIssue(_issueToJson(issue));
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(_toEntity(IssueModel.fromJson(result.data)));
  }

  @override
  Future<Either<Failure, void>> deleteAttachment({
    required String issueId,
    required String storagePath,
  }) async {
    final result = await _api.deleteAttachment(
      issueId,
      storagePath: storagePath,
    );
    if (result.isFailure) return Left(_toFailure(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteIssue(String issueId) async {
    final result = await _api.deleteIssue(issueId);
    if (result.isFailure) return Left(_toFailure(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<IssueAttachment>>> getAttachments(
    String issueId,
  ) async {
    final result = await _api.getAttachments(issueId);
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(result.data.map(_attachmentFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<Build>>> getBuilds(String projectId) async {
    final result = await _api.getBuilds(projectId);
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(result.data.map(_buildFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<Sprint>>> getSprints(String projectId) async {
    final result = await _api.getSprints(projectId);
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(result.data.map(_sprintFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, Issue>> updateIssue(Issue issue) async {
    final result = await _api.updateIssue(issue.id, _issueToJson(issue));
    if (result.isFailure) return Left(_toFailure(result.error));
    return Right(_toEntity(IssueModel.fromJson(result.data)));
  }

  @override
  Future<Either<Failure, void>> updateIssueStarred(
    String issueId,
    bool isStarred,
  ) async {
    final result = await _api.setStarred(issueId, isStarred);
    if (result.isFailure) return Left(_toFailure(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final result = await _api.uploadAttachment(
      issueId,
      filePath: filePath,
      fileName: fileName,
      onProgress: onProgress,
    );
    if (result.isFailure) return Left(_toFailure(result.error));
    onProgress?.call(1.0);
    final path =
        result.data['storagePath'] ?? result.data['path'] ?? result.data['id'];
    return Right(path?.toString() ?? '');
  }
}

JsonObject _issueToJson(Issue issue) => IssueModel(
  id: issue.id,
  projectId: issue.projectId,
  issueKey: issue.issueKey,
  issueNumber: issue.issueNumber,
  summary: issue.summary,
  description: issue.description,
  state: issue.state.name,
  priority: issue.priority.name,
  issueType: issue.issueType.name,
  assigneeId: issue.assigneeId,
  reporterId: issue.reporterId,
  subsystemId: issue.subsystemId,
  parentId: issue.parentId,
  fixVersions: issue.fixVersions,
  buildId: issue.buildId,
  assigneeAvatarUrl: issue.assigneeAvatarUrl,
  createdAt: issue.createdAt,
  updatedAt: issue.updatedAt,
  dueDate: issue.dueDate,
  estimationMinutes: issue.estimation?.inMinutes,
  spentTimeMinutes: issue.spentTime?.inMinutes,
  votes: issue.votes,
  watchersCount: issue.watchersCount,
  attachmentsCount: issue.attachmentsCount,
  commentsCount: issue.commentsCount,
  isStarred: issue.isStarred,
  visibility: issue.visibility,
).toJson();

Tag _tagFromJson(JsonObject json) => Tag(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] ?? '').toString(),
  ownerId: (json['ownerId'] ?? json['owner_id'] ?? '').toString(),
  projectId: (json['projectId'] ?? json['project_id'] ?? '').toString(),
  shared: json['shared'] == true,
  removeOnResolution:
      json['removeOnResolution'] == true ||
      json['remove_on_resolution'] == true,
  favorite: json['favorite'] == true,
  createdAt:
      _date(json['createdAt'] ?? json['created_at']) ??
      DateTime.fromMillisecondsSinceEpoch(0),
  createdBy: (json['createdBy'] ?? json['created_by'] ?? '').toString(),
);

Build _buildFromJson(JsonObject json) => Build(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] ?? '').toString(),
  date: _date(json['date']),
  projectId: (json['projectId'] ?? json['project_id'] ?? '').toString(),
);

Sprint _sprintFromJson(JsonObject json) => Sprint(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] ?? '').toString(),
  startDate: _date(json['start'] ?? json['startDate']),
  releaseDate: _date(json['finish'] ?? json['releaseDate']),
  isReleased: json['archived'] == true || json['isReleased'] == true,
  description: (json['goal'] ?? json['description'] ?? '').toString(),
  projectId: (json['projectId'] ?? json['project_id'] ?? '').toString(),
);

IssueLink _issueLinkFromJson(JsonObject json) {
  final name = (json['linkType'] ?? json['link_type'] ?? json['type'] ?? '')
      .toString();
  IssueLinkType linkType;
  try {
    linkType = IssueLinkType.of(name);
  } on UnimplementedError {
    linkType = IssueLinkType.relatesTo;
  }
  return IssueLink(
    id: (json['id'] ?? '').toString(),
    issueId: (json['issueId'] ?? json['issue_id'] ?? '').toString(),
    linkType: linkType,
    issueLinkedId:
        (json['issueLinkedId'] ??
                json['issue_linked_id'] ??
                json['linkedIssueId'] ??
                '')
            .toString(),
  );
}

IssueAttachment _attachmentFromJson(JsonObject json) => IssueAttachment(
  id: (json['id'] ?? '').toString(),
  fileName: (json['fileName'] ?? json['file_name'] ?? json['name'] ?? '')
      .toString(),
  fileSize:
      int.tryParse(
        (json['fileSize'] ?? json['file_size'] ?? json['size'] ?? 0).toString(),
      ) ??
      0,
  mimeType:
      (json['mimeType'] ?? json['mime_type'] ?? 'application/octet-stream')
          .toString(),
  storagePath: (json['storagePath'] ?? json['storage_path'] ?? json['path'])
      ?.toString(),
  status: AttachmentStatus.uploaded,
);

DateTime? _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '');
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
