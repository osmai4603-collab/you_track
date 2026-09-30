import '../models/user_permissions_model.dart';
import '../network/network_api.dart';
import '../network/network_result.dart';

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
}
