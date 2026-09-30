
import 'network_result.dart';

abstract interface class NetworkAPI {
  Future<ApiResult<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  });
  Future<ApiResult<List<T>>> getList<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  });
  Future<ApiResult<T>> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  });
  Future<ApiResult<T>> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  });
  Future<ApiResult<T>> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  });
  Future<ApiResult<void>> delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });
  Future<ApiResult<T>> head<T>({required String endpoint, Map<String, dynamic>? queryParameters, required T Function(dynamic) fromJson});
}
