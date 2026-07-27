import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/time_tracking_field_type_enum.dart';
import '../../domain/entities/time_tracking_config_entity.dart';
import '../../domain/entities/work_type_entity.dart';
import '../../domain/entities/custom_work_item_attribute_entity.dart';
import '../../domain/repositories/time_tracking_repository.dart';
import '../datasources/time_tracking_remote_data_source.dart';
import '../models/time_tracking_config_model.dart';
import '../models/work_type_model.dart';
import '../models/custom_work_item_attribute_model.dart';

class TimeTrackingRepositoryImpl implements TimeTrackingRepository {
  final TimeTrackingRemoteDataSource remoteDataSource;

  TimeTrackingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> getTimeTrackingConfig(
      String projectId) async {
    try {
      final config = await remoteDataSource.getTimeTrackingConfig(projectId);
      if (config == null) {
        return Left(ServerFailure('Time tracking config not found'));
      }
      return Right(config);
    } catch (e) {
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
}
