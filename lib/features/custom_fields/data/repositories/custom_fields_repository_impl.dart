import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/custom_field_type_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../../domain/repositories/custom_fields_repository.dart';
import '../datasources/custom_fields_remote_data_source.dart';
import '../models/custom_field_model.dart';

class CustomFieldsRepositoryImpl implements CustomFieldsRepository {
  final CustomFieldsRemoteDataSource remoteDataSource;

  CustomFieldsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CustomFieldEntity>>> getFields(
      String projectId) async {
    try {
      final fields = await remoteDataSource.getFields(projectId);
      return Right(fields);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> addField({
    required String projectId,
    required String name,
    required CustomFieldEnumType fieldType,
    String? defaultValue,
  }) async {
    try {
      final fields = await remoteDataSource.getFields(projectId);
      if (fields.any((f) => f.name == name)) {
        return const Left(ValidationFailure('Field name already exists'));
      }

      final maxOrder = fields.isEmpty
          ? 0
          : fields.map((f) => f.orderIndex).reduce(
              (a, b) => a > b ? a : b,
            );

      final model = CustomFieldModel(
        id: '',
        projectId: projectId,
        name: name,
        fieldType: fieldType,
        defaultValue: fieldType.firstAvailableOrDefault(defaultValue),
        orderIndex: maxOrder + 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await remoteDataSource.addField(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomFieldEntity>> updateField({
    required String fieldId,
    String? name,
    CustomFieldEnumType? fieldType,
    String? defaultValue,
  }) async {
    try {
      final current = await remoteDataSource.getFields('');
      final existing = current.where((f) => f.id == fieldId).firstOrNull;
      if (existing == null) {
        return const Left(ServerFailure('Custom field not found'));
      }

      if (name != null && name != existing.name) {
        final duplicate = current.any((f) => f.name == name && f.id != fieldId);
        if (duplicate) {
          return const Left(
            ValidationFailure('Field name already exists'),
          );
        }
      }

      final resolvedType = fieldType ?? existing.fieldType;
      final resolvedDefault = resolvedType.firstAvailableOrDefault(
        fieldType != null ? null : (defaultValue ?? existing.defaultValue),
      );

      final updated = existing.copyWith(
        name: name,
        fieldType: resolvedType,
        defaultValue: resolvedDefault,
        updatedAt: DateTime.now(),
      );

      final result =
          await remoteDataSource.updateField(CustomFieldModel.fromEntity(updated));
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFields(List<String> fieldIds) async {
    try {
      await remoteDataSource.deleteFields(fieldIds);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reorderField({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  }) async {
    try {
      final fields = await remoteDataSource.getFields(projectId);
      if (oldIndex < 0 || oldIndex >= fields.length) {
        return const Left(ValidationFailure('Invalid old index'));
      }
      if (newIndex < 0 || newIndex >= fields.length) {
        return const Left(ValidationFailure('Invalid new index'));
      }

      final reordered = List<CustomFieldModel>.from(fields);
      final moved = reordered.removeAt(oldIndex);
      reordered.insert(newIndex, moved);

      final orderUpdates = reordered.asMap().entries.map((entry) {
        return {'id': entry.value.id, 'order_index': entry.key};
      }).toList();

      await remoteDataSource.reorderFields(projectId, orderUpdates);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
