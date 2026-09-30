
import 'package:youtrack_api/src/network/network_result.dart';
import '../models/models.dart';
import '../network/network_api.dart';

class UsersApi {
  final NetworkAPI _api;
  UsersApi(this._api);

  Future<ApiResult<UserModel>> login(String username, String password) async {
    final result = await _api.post(
      endpoint: '/login',
      data: {
        'username': username,
        'password': password,
      },
      fromJson: UserModel.fromJson,
    );
    return result;
  }
}
