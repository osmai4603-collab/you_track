import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class TimeTrackingApi {
  final JsonApi _json;

  TimeTrackingApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<JsonObject>> getConfig(String projectID) => _json.getObject(
    '/projects/${Uri.encodeComponent(projectID)}/time-tracking',
  );

  Future<ApiResult<JsonObject>> saveConfig(
    String projectID,
    JsonObject config,
  ) => _json.putObject(
    '/projects/${Uri.encodeComponent(projectID)}/time-tracking',
    data: config,
  );

  Future<ApiResult<List<JsonObject>>> getWorkTypes(String projectID) => _json
      .getObjects('/projects/${Uri.encodeComponent(projectID)}/work-types');

  Future<ApiResult<JsonObject>> createWorkType(JsonObject workType) =>
      _json.postObject('/work-types', data: workType);

  Future<ApiResult<JsonObject>> updateWorkType(
    String workTypeID,
    JsonObject workType,
  ) => _json.patchObject(
    '/work-types/${Uri.encodeComponent(workTypeID)}',
    data: workType,
  );

  Future<ApiResult<void>> deleteWorkType(String workTypeID) =>
      _json.deleteVoid('/work-types/${Uri.encodeComponent(workTypeID)}');

  Future<ApiResult<void>> reorderWorkTypes(List<String> orderedIDs) =>
      _json.putVoid('/work-types/order', data: {'orderedIds': orderedIDs});

  Future<ApiResult<List<JsonObject>>> getCustomAttributes(
    String projectID,
  ) => _json.getObjects(
    '/projects/${Uri.encodeComponent(projectID)}/work-item-custom-attributes',
  );

  Future<ApiResult<JsonObject>> createCustomAttribute(JsonObject attribute) =>
      _json.postObject('/work-item-custom-attributes', data: attribute);

  Future<ApiResult<JsonObject>> updateCustomAttribute(
    String attributeID,
    JsonObject attribute,
  ) => _json.patchObject(
    '/work-item-custom-attributes/${Uri.encodeComponent(attributeID)}',
    data: attribute,
  );

  Future<ApiResult<void>> deleteCustomAttribute(String attributeID) =>
      _json.deleteVoid(
        '/work-item-custom-attributes/${Uri.encodeComponent(attributeID)}',
      );

  Future<ApiResult<List<JsonObject>>> getWorkItemAttributes(String projectID) =>
      _json.getObjects(
        '/projects/${Uri.encodeComponent(projectID)}/work-item-attributes',
      );

  Future<ApiResult<JsonObject>> createWorkItemAttribute(JsonObject attribute) =>
      _json.postObject('/work-item-attributes', data: attribute);

  Future<ApiResult<JsonObject>> updateWorkItemAttribute(
    String attributeID,
    JsonObject attribute,
  ) => _json.patchObject(
    '/work-item-attributes/${Uri.encodeComponent(attributeID)}',
    data: attribute,
  );

  Future<ApiResult<void>> deleteWorkItemAttribute(String attributeID) => _json
      .deleteVoid('/work-item-attributes/${Uri.encodeComponent(attributeID)}');

  Future<ApiResult<List<JsonObject>>> getAttributeValues(String attributeID) =>
      _json.getObjects(
        '/work-item-attributes/${Uri.encodeComponent(attributeID)}/values',
      );

  Future<ApiResult<JsonObject>> createAttributeValue(JsonObject value) =>
      _json.postObject('/work-item-attribute-values', data: value);

  Future<ApiResult<JsonObject>> updateAttributeValue(
    String valueID,
    JsonObject value,
  ) => _json.patchObject(
    '/work-item-attribute-values/${Uri.encodeComponent(valueID)}',
    data: value,
  );

  Future<ApiResult<void>> deleteAttributeValue(String valueID) =>
      _json.deleteVoid(
        '/work-item-attribute-values/${Uri.encodeComponent(valueID)}',
      );
}
