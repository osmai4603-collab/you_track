import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class GroupsApi {
  final JsonApi _json;

  GroupsApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getGroups({String? userID}) =>
      _json.getObjects(
        '/groups',
        queryParameters: {
          if (userID != null && userID.isNotEmpty) 'userId': userID,
        },
      );

  Future<ApiResult<JsonObject>> getGroup(String groupID) =>
      _json.getObject('/groups/${Uri.encodeComponent(groupID)}');

  Future<ApiResult<JsonObject>> createGroup(JsonObject group) =>
      _json.postObject('/groups', data: group);

  Future<ApiResult<JsonObject>> updateGroup(String groupID, JsonObject group) =>
      _json.patchObject('/groups/${Uri.encodeComponent(groupID)}', data: group);

  Future<ApiResult<void>> deleteGroup(String groupID) =>
      _json.deleteVoid('/groups/${Uri.encodeComponent(groupID)}');

  Future<ApiResult<List<JsonObject>>> getMembers(String groupID) =>
      _json.getObjects('/groups/${Uri.encodeComponent(groupID)}/members');

  Future<ApiResult<List<JsonObject>>> addMembers(
    String groupID,
    List<String> userIDs,
  ) => _json.postObjects(
    '/groups/${Uri.encodeComponent(groupID)}/members',
    data: {'userIds': userIDs},
  );

  Future<ApiResult<void>> removeMembers(String groupID, List<String> userIDs) =>
      _json.deleteVoid(
        '/groups/${Uri.encodeComponent(groupID)}/members',
        data: {'userIds': userIDs},
      );

  Future<ApiResult<List<JsonObject>>> addProjects(
    String groupID,
    List<String> projectIDs,
  ) => _json.postObjects(
    '/groups/${Uri.encodeComponent(groupID)}/projects',
    data: {'projectIds': projectIDs},
  );

  Future<ApiResult<List<JsonObject>>> getRoles(String groupID) =>
      _json.getObjects('/groups/${Uri.encodeComponent(groupID)}/roles');

  Future<ApiResult<JsonObject>> assignRole(JsonObject assignment) =>
      _json.postObject('/group-role-assignments', data: assignment);

  Future<ApiResult<void>> removeRole({
    required String groupID,
    required String projectID,
  }) => _json.deleteVoid(
    '/groups/${Uri.encodeComponent(groupID)}/roles',
    queryParameters: {'projectId': projectID},
  );
}
