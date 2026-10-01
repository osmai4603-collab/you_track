import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class CustomFieldsApi {
  final JsonApi _json;

  CustomFieldsApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getFields(String projectID) => _json
      .getObjects('/projects/${Uri.encodeComponent(projectID)}/custom-fields');

  Future<ApiResult<JsonObject>> createField(
    String projectID,
    JsonObject field,
  ) => _json.postObject(
    '/projects/${Uri.encodeComponent(projectID)}/custom-fields',
    data: field,
  );

  Future<ApiResult<JsonObject>> updateField(String fieldID, JsonObject field) =>
      _json.patchObject(
        '/custom-fields/${Uri.encodeComponent(fieldID)}',
        data: field,
      );

  Future<ApiResult<void>> deleteFields(List<String> fieldIDs) =>
      _json.deleteVoid('/custom-fields', data: {'ids': fieldIDs});

  Future<ApiResult<void>> reorderFields({
    required String projectID,
    required int oldIndex,
    required int newIndex,
  }) => _json.putVoid(
    '/projects/${Uri.encodeComponent(projectID)}/custom-fields/order',
    data: {'oldIndex': oldIndex, 'newIndex': newIndex},
  );

  Future<ApiResult<JsonObject>> updateVisibility(
    String fieldID,
    String visibility,
  ) => _json.patchObject(
    '/custom-fields/${Uri.encodeComponent(fieldID)}/visibility',
    data: {'visibility': visibility},
  );

  Future<ApiResult<JsonObject>> updateAccessControl(
    String fieldID,
    JsonObject accessControl,
  ) => _json.patchObject(
    '/custom-fields/${Uri.encodeComponent(fieldID)}/access-control',
    data: accessControl,
  );

  Future<ApiResult<void>> replaceValue({
    required String fieldID,
    required String oldValue,
    required String newValue,
  }) => _json.putVoid(
    '/custom-fields/${Uri.encodeComponent(fieldID)}/values/replace',
    data: {'oldValue': oldValue, 'newValue': newValue},
  );

  Future<ApiResult<JsonObject>> updateAdvancedSettings(
    String fieldID,
    JsonObject settings,
  ) => _json.patchObject(
    '/custom-fields/${Uri.encodeComponent(fieldID)}/settings',
    data: settings,
  );

  Future<ApiResult<bool>> isFieldNameUnique({
    required String projectID,
    required String name,
  }) async {
    final result = await _json.getObject(
      '/projects/${Uri.encodeComponent(projectID)}/custom-fields/name-unique',
      queryParameters: {'name': name},
    );
    if (result.isFailure) return ApiFailure(result.error);
    return ApiSuccess(result.data['unique'] == true);
  }
}
