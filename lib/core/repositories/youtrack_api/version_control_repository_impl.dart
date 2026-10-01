import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_commit_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_pull_request_entity.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_user_mapping_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/version_control_repository.dart';
import 'package:issues_tracking/core/enums/server_type_enum.dart';
import 'package:issues_tracking/core/enums/vcs_auth_mode_enum.dart';
import 'package:issues_tracking/core/enums/vcs_connection_status_enum.dart';
import 'package:issues_tracking/core/enums/vcs_pr_state_enum.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class VersionControlRepositoryImpl implements VersionControlRepository {
  final VersionControlApi _api;

  VersionControlRepositoryImpl(this._api);

  @override
  Future<Either<Failure, VcsCommitEntity>> createCommit(
    VcsCommitEntity commit,
  ) async {
    final result = await _api.createCommit(_commitToJson(commit));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_commitFromJson(result.data));
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> createIntegration(
    VcsIntegrationEntity integration,
  ) async {
    final result = await _api.createIntegration(
      _integrationToJson(integration),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_integrationFromJson(result.data));
  }

  @override
  Future<Either<Failure, VcsPullRequestEntity>> createPullRequest(
    VcsPullRequestEntity pullRequest,
  ) async {
    final result = await _api.createPullRequest(
      _pullRequestToJson(pullRequest),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_pullRequestFromJson(result.data));
  }

  @override
  Future<Either<Failure, VcsUserMappingEntity>> createUserMapping(
    VcsUserMappingEntity mapping,
  ) async {
    final result = await _api.createUserMapping(_mappingToJson(mapping));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_mappingFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteIntegration(String integrationId) async {
    final result = await _api.deleteIntegration(integrationId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteUserMapping(String mappingId) async {
    final result = await _api.deleteUserMapping(mappingId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<VcsCommitEntity>>> getCommits(
    String integrationId, {
    String? taskId,
  }) async {
    final result = await _api.getCommits(integrationId, taskID: taskId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_commitFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> getIntegrationById(
    String integrationId,
  ) async {
    final result = await _api.getIntegration(integrationId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_integrationFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<VcsIntegrationEntity>>> getIntegrations(
    String projectId,
  ) async {
    final result = await _api.getIntegrations(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_integrationFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<VcsPullRequestEntity>>> getPullRequests(
    String integrationId, {
    String? taskId,
  }) async {
    final result = await _api.getPullRequests(integrationId, taskID: taskId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_pullRequestFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<VcsUserMappingEntity>>> getUserMappings(
    String integrationId,
  ) async {
    final result = await _api.getUserMappings(integrationId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_mappingFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> testConnection(
    String integrationId,
  ) async {
    final result = await _api.testConnection(integrationId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_integrationFromJson(result.data));
  }

  @override
  Future<Either<Failure, VcsIntegrationEntity>> updateIntegration(
    VcsIntegrationEntity integration,
  ) async {
    final result = await _api.updateIntegration(
      integration.id,
      _integrationToJson(integration),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_integrationFromJson(result.data));
  }

  @override
  Future<Either<Failure, VcsPullRequestEntity>> updatePullRequest(
    VcsPullRequestEntity pullRequest,
  ) async {
    final result = await _api.updatePullRequest(
      pullRequest.id,
      _pullRequestToJson(pullRequest),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_pullRequestFromJson(result.data));
  }
}

VcsIntegrationEntity _integrationFromJson(JsonObject json) {
  VcsProviderType provider;
  VcsAuthMode authMode;
  VcsConnectionStatus status;
  try {
    provider = VcsProviderType.of(
      _text(json, 'providerType', 'provider_type', 'github'),
    );
  } on ArgumentError {
    provider = VcsProviderType.github;
  }
  try {
    authMode = VcsAuthMode.fromValue(
      _text(json, 'authMode', 'auth_mode', 'token'),
    );
  } on ArgumentError {
    authMode = VcsAuthMode.token;
  }
  try {
    status = VcsConnectionStatus.fromValue(
      _text(json, 'status', null, 'connected'),
    );
  } on ArgumentError {
    status = VcsConnectionStatus.connected;
  }
  return VcsIntegrationEntity(
    id: _text(json, 'id'),
    projectId: _text(json, 'projectId', 'project_id'),
    integrationName: _text(json, 'integrationName', 'integration_name'),
    providerType: provider,
    serverUrl: _nullableText(json, 'serverUrl', 'server_url'),
    authMode: authMode,
    encryptedToken: _nullableText(json, 'encryptedToken', 'encrypted_token'),
    sshPrivateKey: _nullableText(json, 'sshPrivateKey', 'ssh_private_key'),
    passphrase: _nullableText(json, 'passphrase'),
    organizationOwner: _text(json, 'organizationOwner', 'organization_owner'),
    repositoryName: _text(json, 'repositoryName', 'repository_name'),
    branchSpecification: _text(
      json,
      'branchSpecification',
      'branch_specification',
      '+:*',
    ),
    parseCommitsForCommands: _bool(
      json,
      'parseCommitsForCommands',
      'parse_commits_for_commands',
    ),
    silentProcessing: _bool(json, 'silentProcessing', 'silent_processing'),
    pullRequestAutomation: _bool(
      json,
      'pullRequestAutomation',
      'pull_request_automation',
    ),
    commandExecutorsGroups: _strings(
      json['commandExecutorsGroups'] ?? json['command_executors_groups'],
    ),
    visibleToRoles:
        _strings(json['visibleToRoles'] ?? json['visible_to_roles']) ??
        const [],
    automaticUserMapping: _bool(
      json,
      'automaticUserMapping',
      'automatic_user_mapping',
      true,
    ),
    status: status,
    createdAt: _date(json['createdAt'] ?? json['created_at']),
    updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
  );
}

JsonObject _integrationToJson(VcsIntegrationEntity value) => {
  'projectId': value.projectId,
  'integrationName': value.integrationName,
  'providerType': value.providerType.name,
  'serverUrl': value.serverUrl,
  'authMode': value.authMode.value,
  'encryptedToken': value.encryptedToken,
  'sshPrivateKey': value.sshPrivateKey,
  'passphrase': value.passphrase,
  'organizationOwner': value.organizationOwner,
  'repositoryName': value.repositoryName,
  'branchSpecification': value.branchSpecification,
  'parseCommitsForCommands': value.parseCommitsForCommands,
  'silentProcessing': value.silentProcessing,
  'pullRequestAutomation': value.pullRequestAutomation,
  'commandExecutorsGroups': value.commandExecutorsGroups,
  'visibleToRoles': value.visibleToRoles,
  'automaticUserMapping': value.automaticUserMapping,
};

VcsUserMappingEntity _mappingFromJson(JsonObject json) => VcsUserMappingEntity(
  id: _text(json, 'id'),
  integrationId: _text(json, 'integrationId', 'integration_id'),
  vcsUsernameOrEmail: _text(
    json,
    'vcsUsernameOrEmail',
    'vcs_username_or_email',
  ),
  youtrackUserId: _text(json, 'youtrackUserId', 'youtrack_user_id'),
  createdAt: _date(json['createdAt'] ?? json['created_at']),
);

JsonObject _mappingToJson(VcsUserMappingEntity value) => {
  'integrationId': value.integrationId,
  'vcsUsernameOrEmail': value.vcsUsernameOrEmail,
  'youtrackUserId': value.youtrackUserId,
};

VcsCommitEntity _commitFromJson(JsonObject json) => VcsCommitEntity(
  id: _text(json, 'id'),
  integrationId: _text(json, 'integrationId', 'integration_id'),
  taskId: _text(json, 'taskId', 'task_id'),
  commitSha: _text(json, 'commitSha', 'commit_sha'),
  authorName: _text(json, 'authorName', 'author_name'),
  authorEmail: _text(json, 'authorEmail', 'author_email'),
  message: _text(json, 'message'),
  branch: _text(json, 'branch'),
  committedAt: _date(json['committedAt'] ?? json['committed_at']),
  processedAt: _date(json['processedAt'] ?? json['processed_at']),
);

JsonObject _commitToJson(VcsCommitEntity value) => {
  'integrationId': value.integrationId,
  'taskId': value.taskId,
  'commitSha': value.commitSha,
  'authorName': value.authorName,
  'authorEmail': value.authorEmail,
  'message': value.message,
  'branch': value.branch,
  'committedAt': value.committedAt.toIso8601String(),
};

VcsPullRequestEntity _pullRequestFromJson(JsonObject json) {
  VcsPrState state;
  try {
    state = VcsPrState.fromValue(_text(json, 'state', null, 'open'));
  } on ArgumentError {
    state = VcsPrState.open;
  }
  return VcsPullRequestEntity(
    id: _text(json, 'id'),
    integrationId: _text(json, 'integrationId', 'integration_id'),
    taskId: _text(json, 'taskId', 'task_id'),
    prNumber: int.tryParse(_text(json, 'prNumber', 'pr_number', '0')) ?? 0,
    title: _text(json, 'title'),
    authorName: _text(json, 'authorName', 'author_name'),
    sourceBranch: _text(json, 'sourceBranch', 'source_branch'),
    targetBranch: _text(json, 'targetBranch', 'target_branch'),
    state: state,
    openedAt: _date(json['openedAt'] ?? json['opened_at']),
    mergedAt: _nullableDate(json['mergedAt'] ?? json['merged_at']),
    closedAt: _nullableDate(json['closedAt'] ?? json['closed_at']),
    createdAt: _date(json['createdAt'] ?? json['created_at']),
  );
}

JsonObject _pullRequestToJson(VcsPullRequestEntity value) => {
  'integrationId': value.integrationId,
  'taskId': value.taskId,
  'prNumber': value.prNumber,
  'title': value.title,
  'authorName': value.authorName,
  'sourceBranch': value.sourceBranch,
  'targetBranch': value.targetBranch,
  'state': value.state.value,
  'openedAt': value.openedAt.toIso8601String(),
  'mergedAt': value.mergedAt?.toIso8601String(),
  'closedAt': value.closedAt?.toIso8601String(),
};

String _text(
  JsonObject json,
  String key, [
  String? alias,
  String fallback = '',
]) =>
    (json[key] ?? (alias == null ? null : json[alias]) ?? fallback).toString();

String? _nullableText(JsonObject json, String key, [String? alias]) {
  final value = json[key] ?? (alias == null ? null : json[alias]);
  return value?.toString();
}

bool _bool(
  JsonObject json,
  String key, [
  String? alias,
  bool fallback = false,
]) {
  final value = json[key] ?? (alias == null ? null : json[alias]);
  if (value is bool) return value;
  return value == null ? fallback : value.toString().toLowerCase() == 'true';
}

List<String>? _strings(Object? value) => value is List
    ? value.map((item) => item.toString()).toList(growable: false)
    : null;

DateTime _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? _nullableDate(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return value == null ? null : DateTime.tryParse(value.toString());
}
