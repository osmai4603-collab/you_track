import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/custom_field_type_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/custom_fields/domain/entities/custom_field_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/custom_fields_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class CustomFieldsRepositoryImpl implements CustomFieldsRepository {
  final CustomFieldsApi _api;

  CustomFieldsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, CustomFieldEntity>> addField({
    required String projectId,
    required String name,
    required CustomFieldEnumType fieldType,
    String? defaultValue,
    String? emptyValue,
    bool canBeEmpty = true,
    String valueMode = 'single',
    List<String>? aliases,
  }) async {
    final result = await _api.createField(projectId, {
      'name': name,
      'fieldType': fieldType.name,
      'defaultValue': defaultValue,
      'emptyValue': emptyValue,
      'canBeEmpty': canBeEmpty,
      'valueMode': valueMode,
      'aliases': aliases,
    });
    return _fieldResult(result);
  }

  @override
  Future<Either<Failure, void>> deleteFields(List<String> fieldIds) async {
    final result = await _api.deleteFields(fieldIds);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<CustomFieldEntity>>> getFields(
    String projectId,
  ) async {
    final result = await _api.getFields(projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_fieldFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> reorderField({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  }) async {
    final result = await _api.reorderFields(
      projectID: projectId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> replaceFieldValue({
    required String fieldId,
    required String oldValue,
    required String newValue,
  }) async {
    final result = await _api.replaceValue(
      fieldID: fieldId,
      oldValue: oldValue,
      newValue: newValue,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateAccessControl({
    required String fieldId,
    required Map<String, dynamic> accessControl,
  }) async {
    final result = await _api.updateAccessControl(fieldId, accessControl);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fieldFromJson(result.data));
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateAdvancedSettings({
    required String fieldId,
    List<String>? visibleTo,
    List<String>? updatableBy,
    String? showOnlyWhen,
    String? filterValuesBasedOn,
  }) async {
    final result = await _api.updateAdvancedSettings(
      fieldId,
      _withoutNulls({
        'visibleTo': visibleTo,
        'updatableBy': updatableBy,
        'showOnlyWhen': showOnlyWhen,
        'filterValuesBasedOn': filterValuesBasedOn,
      }),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fieldFromJson(result.data));
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateField({
    required String fieldId,
    String? name,
    CustomFieldEnumType? fieldType,
    String? defaultValue,
    String? emptyValue,
    bool? canBeEmpty,
    String? valueMode,
    List<String>? aliases,
  }) async {
    final result = await _api.updateField(
      fieldId,
      _withoutNulls({
        'name': name,
        'fieldType': fieldType?.name,
        'defaultValue': defaultValue,
        'emptyValue': emptyValue,
        'canBeEmpty': canBeEmpty,
        'valueMode': valueMode,
        'aliases': aliases,
      }),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fieldFromJson(result.data));
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateVisibility({
    required String fieldId,
    required String visibility,
  }) async {
    final result = await _api.updateVisibility(fieldId, visibility);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fieldFromJson(result.data));
  }

  @override
  Future<Either<Failure, bool>> validateFieldNameUniqueness({
    required String projectId,
    required String name,
  }) async {
    final result = await _api.isFieldNameUnique(
      projectID: projectId,
      name: name,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data);
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> createField({
    required String projectId,
    required String name,
    String? description,
    required CustomFieldEnumType fieldType,
    bool isPrivate = false,
  }) async {
    final result = await _api.createField(projectId, {
      'name': name,
      'description': description,
      'fieldType': fieldType.name,
      'isPrivate': isPrivate,
    });
    return _fieldResult(result);
  }

  static Either<Failure, CustomFieldEntity> _fieldResult(
    ApiResult<JsonObject> result,
  ) {
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fieldFromJson(result.data));
  }
}

CustomFieldEntity _fieldFromJson(JsonObject json) {
  CustomFieldEnumType type;
  try {
    type = CustomFieldEnumType.of(
      (json['fieldType'] ?? json['field_type'] ?? 'string').toString(),
    );
  } on ArgumentError {
    type = CustomFieldEnumType.string;
  }
  return CustomFieldEntity(
    id: (json['id'] ?? '').toString(),
    projectId: (json['projectId'] ?? json['project_id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    fieldType: type,
    fieldMode: (json['fieldMode'] ?? json['field_mode'] ?? 'ownedField')
        .toString(),
    valueMode: (json['valueMode'] ?? json['value_mode'] ?? 'single').toString(),
    defaultValue: json['defaultValue']?.toString(),
    emptyValue: json['emptyValue']?.toString(),
    canBeEmpty: json['canBeEmpty'] != false && json['can_be_empty'] != false,
    aliases: _stringList(json['aliases']),
    visibleTo: _stringList(json['visibleTo'] ?? json['visible_to']),
    updatableBy: _stringList(json['updatableBy'] ?? json['updatable_by']),
    showOnlyWhen: json['showOnlyWhen']?.toString(),
    filterValuesBasedOn: json['filterValuesBasedOn']?.toString(),
    orderIndex:
        int.tryParse(
          (json['orderIndex'] ?? json['order_index'] ?? 0).toString(),
        ) ??
        0,
    visibility: (json['visibility'] ?? 'show').toString(),
    accessControl: json['accessControl'] is Map
        ? Map<String, dynamic>.from(json['accessControl'] as Map)
        : const {'type': 'everyone'},
    createdAt: _date(json['createdAt'] ?? json['created_at']),
    updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
  );
}

List<String>? _stringList(Object? value) => value is List
    ? value.map((item) => item.toString()).toList(growable: false)
    : null;

DateTime _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

JsonObject _withoutNulls(JsonObject values) {
  values.removeWhere((_, value) => value == null);
  return values;
}
