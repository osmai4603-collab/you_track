import 'dart:typed_data';

import 'package:youtrack_api/src/models/user_auth.dart';

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
    void Function(int sent, int total)? onSendProgress,
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
  Future<ApiResult<Map<String, dynamic>>> uploadFile({
    required String endpoint,
    required String filePath,
    required String fileName,
    String fieldName = 'file',
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    void Function(double progress)? onProgress,
  });
  Future<ApiResult<Uint8List>> downloadFile({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResult<T>> head<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  });
  Future<void> onLogin(UserAuth token);
  Future<void> onLogout();
  Future<void> onRefreshToken(UserAuth token);
}
