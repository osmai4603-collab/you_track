import '../network/network_api.dart';
import '../network/network_result.dart';

/// JSON object returned by the YouTrack application API.
typedef JsonObject = Map<String, dynamic>;

/// Small transport helper used by the feature APIs whose domain models live in
/// the application layer. It keeps route definitions in this package while
/// allowing repositories to own their domain-to-JSON mapping.
class JsonApi {
  final NetworkAPI _network;

  const JsonApi(this._network);

  Future<ApiResult<JsonObject>> getObject(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.get(
      endpoint: endpoint,
      queryParameters: queryParameters,
      fromJson: _copyObject,
    );
  }

  Future<ApiResult<List<JsonObject>>> getObjects(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.getList(
      endpoint: endpoint,
      queryParameters: queryParameters,
      fromJson: _copyObject,
    );
  }

  Future<ApiResult<JsonObject>> postObject(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
  }) {
    return _network.post(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
      fromJson: _copyObject,
    );
  }

  Future<ApiResult<List<JsonObject>>> postObjects(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.post(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      fromJson: (json) {
        final raw = json['items'] ?? json['data'];
        if (raw is! List) return const <JsonObject>[];
        return raw
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false);
      },
    );
  }

  Future<ApiResult<void>> postVoid(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.post<void>(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      fromJson: (_) {},
    );
  }

  Future<ApiResult<JsonObject>> putObject(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.put(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      fromJson: _copyObject,
    );
  }

  Future<ApiResult<void>> putVoid(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.put<void>(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      fromJson: (_) {},
    );
  }

  Future<ApiResult<JsonObject>> patchObject(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.patch(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      fromJson: _copyObject,
    );
  }

  Future<ApiResult<void>> patchVoid(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.patch<void>(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      fromJson: (_) {},
    );
  }

  Future<ApiResult<void>> deleteVoid(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _network.delete(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static JsonObject _copyObject(JsonObject object) =>
      Map<String, dynamic>.from(object);
}
