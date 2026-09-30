
import 'package:youtrack_api/src/api/users_api.dart';
import 'network/network_api.dart';

class YoutrackClient {
  final NetworkAPI _api;
  late final UsersApi users;

  YoutrackClient(this._api);

  Future<void> init() async {
    users = UsersApi(_api);
  }
}
