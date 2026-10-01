import 'dart:typed_data';

import 'package:youtrack_api/youtrack_api.dart';
import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_config.dart';
import 'session_controller.dart';

enum ContentType {
  applicationJson('application/json');

  final String value;
  const ContentType(this.value);
}

enum AcceptType {
  applicationJson('application/json');

  final String value;
  const AcceptType(this.value);
}

final class YouTrackNetworkApi implements NetworkAPI {
  late final Dio _dio;
  late final NetworkConfig _config;
  final TokenProvider _authDelegate;
  final SessionController? _sessionController;

  YouTrackNetworkApi(
    this._config, {
    required this._authDelegate,
    required this._sessionController,
    List<Interceptor>? customInterceptors,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _config.baseUrl,
        connectTimeout: _config.connectTimeout,
        receiveTimeout: _config.receiveTimeout,
        headers: {
          'Content-Type': ContentType.applicationJson.value,
          'Accept': AcceptType.applicationJson.value,
          ...?_config.defaultHeaders,
        },
      ),
    );

    _dio.interceptors.add(
      AuthInterceptor(
        _authDelegate,
        sessionController: _sessionController,
        unauthenticatedPaths: _config.unauthenticatedPaths,
      ),
    );
    _dio.interceptors.add(
      RetryInterceptor(dio: _dio, maxRetries: _config.maxRetries),
    );

    if (customInterceptors != null) {
      _dio.interceptors.addAll(customInterceptors);
    }

    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        // requestBody: false,
        // responseBody: false,
        // error: true,
        // request: false,
        // requestHeader: false,
        // responseHeader: false,
        // requestUrl: true,
        // responseUrl: true,
      ),
    );
  }

  @override
  Future<ApiResult<void>> delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    data,
  }) async {
    try {
      await _dio.delete(endpoint, data: data, queryParameters: queryParameters);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> uploadFile({
    required String endpoint,
    required String filePath,
    required String fileName,
    String fieldName = 'file',
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final file = await MultipartFile.fromFile(filePath, filename: fileName);
      final formData = FormData.fromMap({...?fields, fieldName: file});
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: Headers.multipartFormDataContentType),
        onSendProgress: onProgress == null
            ? null
            : (sent, total) {
                if (total > 0) onProgress(sent / total);
              },
      );
      return ApiSuccess(_responseMap(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<Uint8List>> downloadFile({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiSuccess(Uint8List.fromList(response.data ?? const <int>[]));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(_responseMap(response.data)));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<List<T>>> getList<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      final data = response.data;

      // `response.data` is dynamic, so passing `fromJson` straight to `map`
      // resolves the call at runtime, where `List.map` demands a
      // `(dynamic) => dynamic` and rejects a `(Map<String, dynamic>) => T`.
      // Wrapping it in a closure keeps the call statically typed, and lets each
      // element be normalised to a string-keyed map first.
      final List<dynamic> items = data is List ? data : [data];

      return ApiSuccess(
        items
            .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(growable: false),
      );
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> patch<T>({
    required String endpoint,
    data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(_responseMap(response.data)));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> post<T>({
    required String endpoint,
    data,
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      );
      return ApiSuccess(fromJson(_responseMap(response.data)));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> put<T>({
    required String endpoint,
    data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(_responseMap(response.data)));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> head<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.head(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  ApiError mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutError();
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return const NetworkError();
    }
    if (error.response != null) {
      final statusCode = error.response!.statusCode ?? 500;
      if (statusCode == 401) {
        return const AuthError();
      }
      if (statusCode == 302) {
        return const ValidationError(
          "Login successful, it'll redirect to login page to perform the autologin",
        );
      }
      if (statusCode == 403) {
        return const PermissionError(
          'You do not have permission to perform this action',
        );
      }
      if (statusCode == 404) {
        return const ResourceError('Resource not found');
      }
      if (statusCode == 501) {
        return const FeatureError('Feature is disabled');
      }
      if (statusCode == 400) {
        final message =
            error.response?.data?['message']?.toString() ?? 'Bad Request';
        return ValidationError(
          'Invalid or missing parameters in URL or request body\n$message',
        );
      }
      return ServerError(
        code: statusCode,
        message: error.response?.statusMessage ?? 'Server Error',
      );
    }
    return UnknownError(error);
  }

  static Map<String, dynamic> _responseMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    // Successful commands that return no body still use the typed parsing API.
    if (data == null) return const <String, dynamic>{};
    throw const FormatException('Expected a JSON object response');
  }

  @override
  Future<void> onLogin(UserAuth token) async {
    if (token.accessToken.isNotEmpty) {
      await _authDelegate.saveToken(token.accessToken);
      _sessionController?.emit(SessionEvent.restored);
    }
  }

  @override
  Future<void> onLogout() async {
    final hasToken = (await _authDelegate.getAuthToken()) != null;
    await _authDelegate.clearToken();
    if (hasToken) {
      _sessionController?.emit(SessionEvent.loggedOut);
    }
  }

  @override
  Future<void> onRefreshToken(UserAuth token) async {
    if (token.accessToken.isNotEmpty && token.refreshToken.isNotEmpty) {
      await _authDelegate.saveToken(token.accessToken);
    }
  }
}
