import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/custom_work_item_attribute_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/time_tracking_config_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_value_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_type_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/time_tracking_repository.dart';
import 'package:issues_tracking/core/enums/time_tracking_field_type_enum.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class TimeTrackingRepositoryImpl implements TimeTrackingRepository {
  final TimeTrackingApi _api;

  TimeTrackingRepositoryImpl(this._api);

  @override
  Future<Either<Failure, WorkItemAttributeValueEntity>> addAttributeValue({
    required WorkItemAttributeValueEntity value,
  }) async {
    final result = await _api.createAttributeValue(_valueToJson(value));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_valueFromJson(result.data));
  }

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> addCustomAttribute({
    required String projectId,
    required String name,
    required String fieldType,
    required bool isRequired,
    List<String>? options,
  }) async {
    final result = await _api.createCustomAttribute({
      'projectId': projectId,
      'name': name,
      'fieldType': fieldType,
      'isRequired': isRequired,
      'options': options,
    });
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_customAttributeFromJson(result.data));
  }

  @override
  Future<Either<Failure, WorkItemAttributeEntity>> addWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  }) async {
    final result = await _api.createWorkItemAttribute(
      _attributeToJson(attribute),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_attributeFromJson(result.data));
  }

  @override
  Future<Either<Failure, WorkTypeEntity>> addWorkType({
    required String projectId,
    required String name,
    String? description,
  }) async {
    final result = await _api.createWorkType({
      'projectId': projectId,
      'name': name,
      'description': description,
    });
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_workTypeFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteAttributeValue(String valueId) async {
    final result = await _api.deleteAttributeValue(valueId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteCustomAttribute(
    String attributeId,
  ) async {
    final result = await _api.deleteCustomAttribute(attributeId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteWorkItemAttribute(
    String attributeId,
  ) async {
    final result = await _api.deleteWorkItemAttribute(attributeId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteWorkType(String workTypeId) async {
    final result = await _api.deleteWorkType(workTypeId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<WorkItemAttributeValueEntity>>>
  getAttributeValues(String attributeId) async {
    final result = await _api.getAttributeValues(attributeId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_valueFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<CustomWorkItemAttributeEntity>>>
  getCustomAttributes(String projectId) async {
    final result = await _api.getCustomAttributes(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(
      result.data.map(_customAttributeFromJson).toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> getTimeTrackingConfig(
    String projectId,
  ) async {
    final result = await _api.getConfig(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_configFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<WorkItemAttributeEntity>>> getWorkItemAttributes(
    String projectId,
  ) async {
    final result = await _api.getWorkItemAttributes(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_attributeFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, List<WorkTypeEntity>>> getWorkTypes(
    String projectId,
  ) async {
    final result = await _api.getWorkTypes(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_workTypeFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> reorderWorkTypes(
    List<String> orderedIds,
  ) async {
    final result = await _api.reorderWorkTypes(orderedIds);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> saveTimeTrackingConfig(
    TimeTrackingConfigEntity config,
  ) async {
    final result = await _api.saveConfig(
      config.projectId,
      _configToJson(config),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_configFromJson(result.data));
  }

  @override
  Future<Either<Failure, WorkItemAttributeValueEntity>> updateAttributeValue({
    required WorkItemAttributeValueEntity value,
  }) async {
    final result = await _api.updateAttributeValue(
      value.id,
      _valueToJson(value),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_valueFromJson(result.data));
  }

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> updateCustomAttribute({
    required String attributeId,
    String? name,
    String? fieldType,
    bool? isRequired,
    List<String>? options,
  }) async {
    final result = await _api.updateCustomAttribute(
      attributeId,
      _withoutNulls({
        'name': name,
        'fieldType': fieldType,
        'isRequired': isRequired,
        'options': options,
      }),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_customAttributeFromJson(result.data));
  }

  @override
  Future<Either<Failure, WorkItemAttributeEntity>> updateWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  }) async {
    final result = await _api.updateWorkItemAttribute(
      attribute.id,
      _attributeToJson(attribute),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_attributeFromJson(result.data));
  }

  @override
  Future<Either<Failure, WorkTypeEntity>> updateWorkType({
    required String workTypeId,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    final result = await _api.updateWorkType(
      workTypeId,
      _withoutNulls({
        'name': name,
        'description': description,
        'isActive': isActive,
      }),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_workTypeFromJson(result.data));
  }
}

TimeTrackingConfigEntity _configFromJson(JsonObject json) =>
    TimeTrackingConfigEntity(
      projectId: _string(json, 'projectId', 'project_id'),
      enabled: _bool(json, 'enabled'),
      estimationFieldId: _optionalString(
        json,
        'estimationFieldId',
        'estimation_field_id',
      ),
      spentTimeFieldId: _optionalString(
        json,
        'spentTimeFieldId',
        'spent_time_field_id',
      ),
      aggregateSpentTime: _bool(
        json,
        'aggregateSpentTime',
        'aggregate_spent_time',
      ),
      aggregateEstimation: _bool(
        json,
        'aggregateEstimation',
        'aggregate_estimation',
      ),
      updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
    );

JsonObject _configToJson(TimeTrackingConfigEntity config) => {
  'enabled': config.enabled,
  'estimationFieldId': config.estimationFieldId,
  'spentTimeFieldId': config.spentTimeFieldId,
  'aggregateSpentTime': config.aggregateSpentTime,
  'aggregateEstimation': config.aggregateEstimation,
};

WorkTypeEntity _workTypeFromJson(JsonObject json) => WorkTypeEntity(
  id: _string(json, 'id'),
  projectId: _string(json, 'projectId', 'project_id'),
  name: _string(json, 'name'),
  description: _optionalString(json, 'description'),
  isActive: _bool(json, 'isActive', 'is_active', true),
  sortOrder: _int(json, 'sortOrder', 'sort_order'),
  createdAt: _date(json['createdAt'] ?? json['created_at']),
  updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
);

CustomWorkItemAttributeEntity _customAttributeFromJson(JsonObject json) {
  TimeTrackingFieldType type;
  try {
    type = TimeTrackingFieldType.fromValue(
      _string(json, 'fieldType', 'field_type', 'text'),
    );
  } on ArgumentError {
    type = TimeTrackingFieldType.text;
  }
  final rawOptions = json['options'];
  return CustomWorkItemAttributeEntity(
    id: _string(json, 'id'),
    projectId: _string(json, 'projectId', 'project_id'),
    name: _string(json, 'name'),
    fieldType: type,
    isRequired: _bool(json, 'isRequired', 'is_required'),
    options: rawOptions is List
        ? rawOptions.map((value) => value.toString()).toList()
        : null,
    sortOrder: _int(json, 'sortOrder', 'sort_order'),
    createdAt: _date(json['createdAt'] ?? json['created_at']),
    updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
  );
}

WorkItemAttributeEntity _attributeFromJson(JsonObject json) =>
    WorkItemAttributeEntity(
      id: _string(json, 'id'),
      name: _string(json, 'name'),
      projectId: _string(json, 'projectId', 'project_id'),
      values: (json['values'] is List ? json['values'] as List : const [])
          .whereType<Map>()
          .map((value) => _valueFromJson(Map<String, dynamic>.from(value)))
          .toList(growable: false),
    );

JsonObject _attributeToJson(WorkItemAttributeEntity attribute) => {
  'id': attribute.id,
  'name': attribute.name,
  'projectId': attribute.projectId,
  'values': attribute.values.map(_valueToJson).toList(growable: false),
};

WorkItemAttributeValueEntity _valueFromJson(JsonObject json) =>
    WorkItemAttributeValueEntity(
      id: _string(json, 'id'),
      value: _string(json, 'value'),
      color: _int(json, 'color'),
      attributeId: _string(json, 'attributeId', 'attribute_id'),
      firstLetter: _string(json, 'firstLetter', 'first_letter'),
    );

JsonObject _valueToJson(WorkItemAttributeValueEntity value) => {
  'id': value.id,
  'value': value.value,
  'color': value.color,
  'attributeId': value.attributeId,
  'firstLetter': value.firstLetter,
};

String _string(
  JsonObject json,
  String key, [
  String? alias,
  String fallback = '',
]) =>
    (json[key] ?? (alias == null ? null : json[alias]) ?? fallback).toString();

String? _optionalString(JsonObject json, String key, [String? alias]) {
  final value = json[key] ?? (alias == null ? null : json[alias]);
  return value?.toString();
}

bool _bool(
  JsonObject json,
  String key, [
  String? alias,
  bool fallback = false,
]) {
  final value = json[key] ?? (alias == null ? null : json[alias]);
  if (value is bool) return value;
  return value == null ? fallback : value.toString().toLowerCase() == 'true';
}

int _int(JsonObject json, String key, [String? alias]) =>
    int.tryParse(
      (json[key] ?? (alias == null ? null : json[alias]) ?? 0).toString(),
    ) ??
    0;

DateTime _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

JsonObject _withoutNulls(JsonObject values) {
  values.removeWhere((_, value) => value == null);
  return values;
}
