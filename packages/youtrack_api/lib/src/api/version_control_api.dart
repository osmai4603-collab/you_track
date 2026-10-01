import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class VersionControlApi {
  final JsonApi _json;

  VersionControlApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getIntegrations(String projectID) =>
      _json.getObjects(
        '/projects/${Uri.encodeComponent(projectID)}/vcs-integrations',
      );

  Future<ApiResult<JsonObject>> getIntegration(String integrationID) => _json
      .getObject('/vcs-integrations/${Uri.encodeComponent(integrationID)}');

  Future<ApiResult<JsonObject>> createIntegration(JsonObject integration) =>
      _json.postObject('/vcs-integrations', data: integration);

  Future<ApiResult<JsonObject>> updateIntegration(
    String integrationID,
    JsonObject integration,
  ) => _json.patchObject(
    '/vcs-integrations/${Uri.encodeComponent(integrationID)}',
    data: integration,
  );

  Future<ApiResult<void>> deleteIntegration(String integrationID) => _json
      .deleteVoid('/vcs-integrations/${Uri.encodeComponent(integrationID)}');

  Future<ApiResult<JsonObject>> testConnection(String integrationID) =>
      _json.postObject(
        '/vcs-integrations/${Uri.encodeComponent(integrationID)}/test',
      );

  Future<ApiResult<List<JsonObject>>> getUserMappings(String integrationID) =>
      _json.getObjects(
        '/vcs-integrations/${Uri.encodeComponent(integrationID)}/user-mappings',
      );

  Future<ApiResult<JsonObject>> createUserMapping(JsonObject mapping) =>
      _json.postObject('/vcs-user-mappings', data: mapping);

  Future<ApiResult<void>> deleteUserMapping(String mappingID) =>
      _json.deleteVoid('/vcs-user-mappings/${Uri.encodeComponent(mappingID)}');

  Future<ApiResult<List<JsonObject>>> getCommits(
    String integrationID, {
    String? taskID,
  }) => _json.getObjects(
    '/vcs-integrations/${Uri.encodeComponent(integrationID)}/commits',
    queryParameters: {
      if (taskID != null && taskID.isNotEmpty) 'taskId': taskID,
    },
  );

  Future<ApiResult<JsonObject>> createCommit(JsonObject commit) =>
      _json.postObject('/vcs-commits', data: commit);

  Future<ApiResult<List<JsonObject>>> getPullRequests(
    String integrationID, {
    String? taskID,
  }) => _json.getObjects(
    '/vcs-integrations/${Uri.encodeComponent(integrationID)}/pull-requests',
    queryParameters: {
      if (taskID != null && taskID.isNotEmpty) 'taskId': taskID,
    },
  );

  Future<ApiResult<JsonObject>> createPullRequest(JsonObject pullRequest) =>
      _json.postObject('/vcs-pull-requests', data: pullRequest);

  Future<ApiResult<JsonObject>> updatePullRequest(
    String pullRequestID,
    JsonObject pullRequest,
  ) => _json.patchObject(
    '/vcs-pull-requests/${Uri.encodeComponent(pullRequestID)}',
    data: pullRequest,
  );
}
