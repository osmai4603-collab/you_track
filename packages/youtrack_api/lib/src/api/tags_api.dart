import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class TagsApi {
  final JsonApi _json;

  TagsApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<JsonObject>> createTag(JsonObject tag) =>
      _json.postObject('/tags', data: tag);

  Future<ApiResult<List<JsonObject>>> getTags({
    Map<String, dynamic>? queryParameters,
  }) => _json.getObjects('/tags', queryParameters: queryParameters);

  Future<ApiResult<void>> associateWithIssue({
    required String issueID,
    required String tagID,
  }) => _json.postVoid(
    '/issues/${Uri.encodeComponent(issueID)}/tags',
    data: {'tagId': tagID},
  );

  Future<ApiResult<List<JsonObject>>> getTagsByIssue(String issueID) =>
      _json.getObjects('/issues/${Uri.encodeComponent(issueID)}/tags');

  Future<ApiResult<List<JsonObject>>> getLinksByIssue(String issueID) =>
      _json.getObjects('/issues/${Uri.encodeComponent(issueID)}/links');

  Future<ApiResult<List<JsonObject>>> getProjectGroups(String projectID) =>
      _json.getObjects('/projects/${Uri.encodeComponent(projectID)}/groups');

  Future<ApiResult<List<JsonObject>>> getProjectMembers(String projectID) =>
      _json.getObjects('/projects/${Uri.encodeComponent(projectID)}/members');

  Future<ApiResult<bool>> isNameUnique({
    required String projectID,
    required String name,
  }) async {
    final result = await _json.getObject(
      '/projects/${Uri.encodeComponent(projectID)}/tags/unique',
      queryParameters: {'name': name},
    );
    if (result.isFailure) return ApiFailure(result.error);
    return ApiSuccess(result.data['unique'] == true);
  }
}
