import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/time_tracking_field_type_enum.dart';
import '../../domain/entities/time_tracking_config_entity.dart';
import '../../domain/entities/work_type_entity.dart';
import '../../domain/entities/custom_work_item_attribute_entity.dart';
import '../../domain/entities/work_item_attribute_entity.dart';
import '../../domain/entities/work_item_attribute_value_entity.dart';
import '../../domain/repositories/time_tracking_repository.dart';
import '../datasources/time_tracking_remote_data_source.dart';
import '../models/time_tracking_config_model.dart';
import '../models/work_type_model.dart';
import '../models/custom_work_item_attribute_model.dart';
import '../models/work_item_attribute_model.dart';
import '../models/attribute_value_model.dart';

class TimeTrackingRepositoryImpl implements TimeTrackingRepository {
  final TimeTrackingRemoteDataSource remoteDataSource;

  TimeTrackingRepositoryImpl(this.remoteDataSource);

  static bool _isMissingTableError(Object error) {
    if (error is PostgrestException) {
      final message = error.message.toLowerCase();
      return error.code == 'PGRST205' ||
          message.contains('could not find the table') ||
          message.contains('does not exist');
    }
    return false;
  }

  TimeTrackingConfigEntity _defaultConfig(String projectId) {
    return TimeTrackingConfigEntity(
      projectId: projectId,
      enabled: false,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> getTimeTrackingConfig(
      String projectId) async {
    try {
      final config = await remoteDataSource.getTimeTrackingConfig(projectId);
      if (config == null) {
        return Right(_defaultConfig(projectId));
      }
      return Right(config);
    } catch (e) {
      if (_isMissingTableError(e)) {
        return Right(_defaultConfig(projectId));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> saveTimeTrackingConfig(
      TimeTrackingConfigEntity config) async {
    try {
      final model = TimeTrackingConfigModel.fromEntity(config);
      final result = await remoteDataSource.saveTimeTrackingConfig(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkTypeEntity>>> getWorkTypes(
      String projectId) async {
    try {
      final workTypes = await remoteDataSource.getWorkTypes(projectId);
      return Right(workTypes);
    } catch (e) {
      if (_isMissingTableError(e)) {
        return const Right([]);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkTypeEntity>> addWorkType({
    required String projectId,
    required String name,
    String? description,
  }) async {
    try {
      final existing = await remoteDataSource.getWorkTypes(projectId);
      final duplicate = existing.any((w) => w.name == name);
      if (duplicate) {
        return const Left(ValidationFailure('Work type name already exists'));
      }

      final model = WorkTypeModel(
        id: '',
        projectId: projectId,
        name: name,
        description: description,
        sortOrder: existing.length,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final result = await remoteDataSource.addWorkType(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkTypeEntity>> updateWorkType({
    required String workTypeId,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    try {
      final workTypes = await remoteDataSource.getWorkTypes('');
      final existing = workTypes.where((w) => w.id == workTypeId).firstOrNull;
      if (existing == null) {
        return const Left(ServerFailure('Work type not found'));
      }

      if (name != null && name != existing.name) {
        final allWorkTypes = await remoteDataSource.getWorkTypes(existing.projectId);
        final duplicate = allWorkTypes.any((w) => w.name == name && w.id != workTypeId);
        if (duplicate) {
          return const Left(ValidationFailure('Work type name already exists'));
        }
      }

      final updated = existing.copyWith(
        name: name,
        description: description,
        isActive: isActive,
        updatedAt: DateTime.now(),
      );
      final result = await remoteDataSource.updateWorkType(
          WorkTypeModel.fromEntity(updated));
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkType(String workTypeId) async {
    try {
      await remoteDataSource.deleteWorkType(workTypeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reorderWorkTypes(List<String> orderedIds) async {
    try {
      final orderUpdates = orderedIds
          .asMap()
          .entries
          .map((entry) => {'id': entry.value, 'sort_order': entry.key})
          .toList();
      await remoteDataSource.reorderWorkTypes(orderUpdates);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomWorkItemAttributeEntity>>> getCustomAttributes(
      String projectId) async {
    try {
      final attributes = await remoteDataSource.getCustomAttributes(projectId);
      return Right(attributes);
    } catch (e) {
      if (_isMissingTableError(e)) {
        return const Right([]);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> addCustomAttribute({
    required String projectId,
    required String name,
    required String fieldType,
    bool isRequired = false,
    List<String>? options,
  }) async {
    try {
      final existing = await remoteDataSource.getCustomAttributes(projectId);
      final duplicate = existing.any((a) => a.name == name);
      if (duplicate) {
        return const Left(
            ValidationFailure('Custom attribute name already exists'));
      }

      final typeEnum = TimeTrackingFieldType.fromValue(fieldType);
      final model = CustomWorkItemAttributeModel(
        id: '',
        projectId: projectId,
        name: name,
        fieldType: typeEnum,
        isRequired: isRequired,
        options: options,
        sortOrder: existing.length,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final result = await remoteDataSource.addCustomAttribute(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> updateCustomAttribute({
    required String attributeId,
    String? name,
    String? fieldType,
    bool? isRequired,
    List<String>? options,
  }) async {
    try {
      final attributes = await remoteDataSource.getCustomAttributes('');
      final existing =
          attributes.where((a) => a.id == attributeId).firstOrNull;
      if (existing == null) {
        return const Left(ServerFailure('Custom attribute not found'));
      }

      if (name != null && name != existing.name) {
        final allAttributes =
            await remoteDataSource.getCustomAttributes(existing.projectId);
        final duplicate =
            allAttributes.any((a) => a.name == name && a.id != attributeId);
        if (duplicate) {
          return const Left(
              ValidationFailure('Custom attribute name already exists'));
        }
      }

      final typeEnum =
          fieldType != null ? TimeTrackingFieldType.fromValue(fieldType) : null;
      final updated = existing.copyWith(
        name: name,
        fieldType: typeEnum,
        isRequired: isRequired,
        options: options,
        updatedAt: DateTime.now(),
      );
      final result = await remoteDataSource.updateCustomAttribute(
          CustomWorkItemAttributeModel.fromEntity(updated));
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomAttribute(String attributeId) async {
    try {
      await remoteDataSource.deleteCustomAttribute(attributeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkItemAttributeEntity>>> getWorkItemAttributes(
      String projectId) async {
    try {
      final attributes = await remoteDataSource.getWorkItemAttributes(projectId);
      return Right(attributes);
    } catch (e) {
      if (_isMissingTableError(e)) {
        return const Right([]);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkItemAttributeEntity>> addWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  }) async {
    try {
      final result = await remoteDataSource.addWorkItemAttribute(
        WorkItemAttributeModel.fromEntity(attribute),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkItemAttributeEntity>> updateWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  }) async {
    try {
      final result = await remoteDataSource.updateWorkItemAttribute(
        WorkItemAttributeModel.fromEntity(attribute),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkItemAttribute(String attributeId) async {
    try {
      await remoteDataSource.deleteWorkItemAttribute(attributeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkItemAttributeValueEntity>>> getAttributeValues(
      String attributeId) async {
    try {
      final values = await remoteDataSource.getAttributeValues(attributeId);
      return Right(values);
    } catch (e) {
      if (_isMissingTableError(e)) {
        return const Right([]);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkItemAttributeValueEntity>> addAttributeValue({
    required WorkItemAttributeValueEntity value,
  }) async {
    try {
      final result = await remoteDataSource.addAttributeValue(
        AttributeValueModel.fromEntity(value),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkItemAttributeValueEntity>> updateAttributeValue({
    required WorkItemAttributeValueEntity value,
  }) async {
    try {
      final result = await remoteDataSource.updateAttributeValue(
        AttributeValueModel.fromEntity(value),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttributeValue(String valueId) async {
    try {
      await remoteDataSource.deleteAttributeValue(valueId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
