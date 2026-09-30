
import 'package:youtrack_api/src/network/network_api.dart';
import 'package:youtrack_api/src/network/network_result.dart';
import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_config.dart';
import 'package:youtrack_api/src/network/network_error.dart';
import 'package:youtrack_api/src/config/token_provider.dart';
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

  YouTrackNetworkApi(this._config, {
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
  Future<ApiResult<void>> delete({required String endpoint, Map<String, dynamic>? queryParameters, data}) async {
    try {
      await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> get<T>({required String endpoint, Map<String, dynamic>? queryParameters, required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await _dio.get(
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

  @override
  Future<ApiResult<List<T>>> getList<T>({required String endpoint, Map<String, dynamic>? queryParameters, required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      if (response.data is List) {
        return ApiSuccess(response.data.map(fromJson).toList());
      }
      return ApiSuccess([fromJson(response.data)]);
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> patch<T>({required String endpoint, data, Map<String, dynamic>? queryParameters, required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> post<T>({required String endpoint, data, Map<String, dynamic>? queryParameters, required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> put<T>({required String endpoint, data, Map<String, dynamic>? queryParameters, required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  @override
  Future<ApiResult<T>> head<T>({required String endpoint, Map<String, dynamic>? queryParameters, required T Function(dynamic) fromJson}) async {
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
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
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
}