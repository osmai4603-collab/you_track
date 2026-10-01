import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class UserProfileApi {
  final JsonApi _json;

  UserProfileApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<JsonObject>> getPreferences(String userID) =>
      _json.getObject('/users/${Uri.encodeComponent(userID)}/preferences');

  Future<ApiResult<JsonObject>> savePreferences(
    String userID,
    JsonObject preferences,
  ) => _json.putObject(
    '/users/${Uri.encodeComponent(userID)}/preferences',
    data: preferences,
  );

  Future<ApiResult<JsonObject>> getNotificationSettings(String userID) => _json
      .getObject('/users/${Uri.encodeComponent(userID)}/notification-settings');

  Future<ApiResult<JsonObject>> saveNotificationSettings(
    String userID,
    JsonObject settings,
  ) => _json.putObject(
    '/users/${Uri.encodeComponent(userID)}/notification-settings',
    data: settings,
  );

  Future<ApiResult<List<JsonObject>>> getSavedSearches(String userID) =>
      _json.getObjects('/users/${Uri.encodeComponent(userID)}/saved-searches');

  Future<ApiResult<JsonObject>> createSavedSearch(JsonObject search) =>
      _json.postObject('/saved-searches', data: search);

  Future<ApiResult<void>> deleteSavedSearch(String searchID) =>
      _json.deleteVoid('/saved-searches/${Uri.encodeComponent(searchID)}');

  Future<ApiResult<List<JsonObject>>> getUserTags(String userID) =>
      _json.getObjects('/users/${Uri.encodeComponent(userID)}/tags');

  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _json.putVoid(
    '/users/me/password',
    data: {'currentPassword': currentPassword, 'newPassword': newPassword},
  );

  Future<ApiResult<void>> revokeRefreshToken() =>
      _json.postVoid('/auth/revoke-refresh-token');
}
