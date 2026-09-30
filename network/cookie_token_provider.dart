
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtrack_api/src/config/token_provider.dart';
import 'session_controller.dart';


const tokenKey = "session_cookie";


class CookieTokenProvider implements TokenProvider {
  final SharedPreferences _prefs;
  final SessionController _sessionController;

  const CookieTokenProvider(this._prefs, this._sessionController);

  @override
  Future<String?> getAuthToken() async {
    return _prefs.getString(tokenKey);
  }

  @override
  Future<void> onAuthenticationError() async {
    await _prefs.setString(tokenKey, '');
    _sessionController.emit(SessionEvent.expired);
  }

}