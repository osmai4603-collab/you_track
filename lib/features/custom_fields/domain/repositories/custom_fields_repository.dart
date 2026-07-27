import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/custom_field_type_enum.dart';
import '../entities/custom_field_entity.dart';

abstract class CustomFieldsRepository {
  Future<Either<Failure, List<CustomFieldEntity>>> getFields(String projectId);

  Future<Either<Failure, CustomFieldEntity>> addField({
    required String projectId,
    required String name,
    required CustomFieldEnumType fieldType,
    String? defaultValue,
  });

  Future<Either<Failure, CustomFieldEntity>> updateField({
    required String fieldId,
    String? name,
    CustomFieldEnumType? fieldType,
    String? defaultValue,
  });

  Future<Either<Failure, void>> deleteFields(List<String> fieldIds);

  Future<Either<Failure, void>> reorderField({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  });

  Future<Either<Failure, CustomFieldEntity>> updateVisibility({
    required String fieldId,
    required String visibility,
  });

  Future<Either<Failure, CustomFieldEntity>> updateAccessControl({
    required String fieldId,
    required Map<String, dynamic> accessControl,
  });

  Future<Either<Failure, void>> replaceFieldValue({
    required String fieldId,
    required String oldValue,
    required String newValue,
  });
}
