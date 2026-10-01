import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class RolesApi {
  final JsonApi _json;

  RolesApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getRoles() => _json.getObjects('/roles');

  Future<ApiResult<JsonObject>> getRole(String name) =>
      _json.getObject('/roles/${Uri.encodeComponent(name)}');

  Future<ApiResult<JsonObject>> createRole(JsonObject role) =>
      _json.postObject('/roles', data: role);

  Future<ApiResult<JsonObject>> updateRole(String name, JsonObject role) =>
      _json.putObject('/roles/${Uri.encodeComponent(name)}', data: role);

  Future<ApiResult<void>> deleteRole(String name) =>
      _json.deleteVoid('/roles/${Uri.encodeComponent(name)}');
}
