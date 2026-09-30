import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/enums/custom_field_type_enum.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/custom_fields/domain/entities/custom_field_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/custom_fields_repository.dart';

class CustomFieldsRepositoryImpl implements CustomFieldsRepository {
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
  }) {
    // TODO: implement addField
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteFields(List<String> fieldIds) {
    // TODO: implement deleteFields
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CustomFieldEntity>>> getFields(String projectId) {
    // TODO: implement getFields
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> reorderField({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  }) {
    // TODO: implement reorderField
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> replaceFieldValue({
    required String fieldId,
    required String oldValue,
    required String newValue,
  }) {
    // TODO: implement replaceFieldValue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateAccessControl({
    required String fieldId,
    required Map<String, dynamic> accessControl,
  }) {
    // TODO: implement updateAccessControl
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateAdvancedSettings({
    required String fieldId,
    List<String>? visibleTo,
    List<String>? updatableBy,
    String? showOnlyWhen,
    String? filterValuesBasedOn,
  }) {
    // TODO: implement updateAdvancedSettings
    throw UnimplementedError();
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
  }) {
    // TODO: implement updateField
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateVisibility({
    required String fieldId,
    required String visibility,
  }) {
    // TODO: implement updateVisibility
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> validateFieldNameUniqueness({
    required String projectId,
    required String name,
  }) {
    // TODO: implement validateFieldNameUniqueness
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> createField({
    required String projectId,
    required String name,
    String? description,
    required CustomFieldEnumType fieldType,
    bool isPrivate = false,
  }) {
    // TODO: implement createField
    throw UnimplementedError();
  }
}
