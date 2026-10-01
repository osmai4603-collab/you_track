import '../models/user_permissions_model.dart';
import '../models/user_model.dart';
import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class UsersApi {
  final NetworkAPI _api;
  UsersApi(this._api);

  /// Fetches the role assignments and owned projects of the authenticated user.
  /// The endpoint takes no user id: the server derives it from the access
  /// token, so a client cannot read somebody else's permissions.
  Future<ApiResult<UserPermissionsModel>> getMyPermissions() {
    return _api.get(
      endpoint: '/users/me/permissions',
      fromJson: UserPermissionsModel.fromJson,
    );
  }

  Future<ApiResult<List<UserModel>>> getUsers({
    Map<String, dynamic>? queryParameters,
  }) {
    return _api.getList(
      endpoint: '/users',
      queryParameters: queryParameters,
      fromJson: UserModel.fromJson,
    );
  }

  Future<ApiResult<UserModel>> getUserByID(String userID) {
    return _api.get(
      endpoint: '/users/${Uri.encodeComponent(userID)}',
      fromJson: UserModel.fromJson,
    );
  }

  Future<ApiResult<UserModel>> createUser(JsonObject user, {String? password}) {
    final payload = Map<String, dynamic>.from(user);
    if (password != null) payload['password'] = password;
    return _api.post(
      endpoint: '/users',
      data: payload,
      fromJson: UserModel.fromJson,
    );
  }

  Future<ApiResult<UserModel>> updateUser(String userID, JsonObject user) {
    return _api.patch(
      endpoint: '/users/${Uri.encodeComponent(userID)}',
      data: user,
      fromJson: UserModel.fromJson,
    );
  }

  Future<ApiResult<void>> deleteUser(String userID) {
    return JsonApi(_api).deleteVoid('/users/${Uri.encodeComponent(userID)}');
  }
}
