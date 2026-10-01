import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'session_controller.dart';

const tokenKey = "auth_token";

class TokenStorageProvider implements TokenProvider {
  final SharedPreferences _prefs;
  final SessionController _sessionController;

  const TokenStorageProvider(this._prefs, this._sessionController);

  @override
  Future<String?> getAuthToken() async {
    final token = _prefs.getString(tokenKey);
    return (token == null || token.isEmpty) ? null : token;
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(tokenKey);
  }

  @override
  Future<void> onAuthenticationError() async {
    await clearToken();
    _sessionController.emit(SessionEvent.expired);
  }
}
