import 'package:dio/dio.dart';
import 'package:youtrack_api/src/config/token_provider.dart';
import '../session_controller.dart';

class AuthInterceptor extends Interceptor {
  final TokenProvider _authDelegate;
  final SessionController? _sessionController;
  final List<String> unauthenticatedPaths;

  AuthInterceptor(
    this._authDelegate, {
    this._sessionController,
    this.unauthenticatedPaths = const ['/auth/login', '/auth/refresh'],
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isUnauthenticated = unauthenticatedPaths.any(
      (p) => options.path.endsWith(p),
    );

    if (!isUnauthenticated) {
      final token = await _authDelegate.getAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Cookie'] = 'youtrack_session=$token';
      }
    }
    options.headers['X-Requested-With'] = 'XMLHttpRequest';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _authDelegate.onAuthenticationError();
      _sessionController?.emit(SessionEvent.expired);
    }
    handler.next(err);
  }
}
