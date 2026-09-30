import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/time_tracking/domain/entities/custom_work_item_attribute_entity.dart';
import 'package:youtrack_frontend/features/time_tracking/domain/entities/time_tracking_config_entity.dart';
import 'package:youtrack_frontend/features/time_tracking/domain/entities/work_item_attribute_entity.dart';
import 'package:youtrack_frontend/features/time_tracking/domain/entities/work_item_attribute_value_entity.dart';
import 'package:youtrack_frontend/features/time_tracking/domain/entities/work_type_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/time_tracking_repository.dart';

class TimeTrackingRepositoryImpl implements TimeTrackingRepository {
  @override
  Future<Either<Failure, WorkItemAttributeValueEntity>> addAttributeValue({
    required WorkItemAttributeValueEntity value,
  }) {
    // TODO: implement addAttributeValue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> addCustomAttribute({
    required String projectId,
    required String name,
    required String fieldType,
    required bool isRequired,
    List<String>? options,
  }) {
    // TODO: implement addCustomAttribute
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkItemAttributeEntity>> addWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  }) {
    // TODO: implement addWorkItemAttribute
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkTypeEntity>> addWorkType({
    required String projectId,
    required String name,
    String? description,
  }) {
    // TODO: implement addWorkType
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteAttributeValue(String valueId) {
    // TODO: implement deleteAttributeValue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteCustomAttribute(String attributeId) {
    // TODO: implement deleteCustomAttribute
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteWorkItemAttribute(String attributeId) {
    // TODO: implement deleteWorkItemAttribute
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteWorkType(String workTypeId) {
    // TODO: implement deleteWorkType
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<WorkItemAttributeValueEntity>>>
  getAttributeValues(String attributeId) {
    // TODO: implement getAttributeValues
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CustomWorkItemAttributeEntity>>>
  getCustomAttributes(String projectId) {
    // TODO: implement getCustomAttributes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> getTimeTrackingConfig(
    String projectId,
  ) {
    // TODO: implement getTimeTrackingConfig
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<WorkItemAttributeEntity>>> getWorkItemAttributes(
    String projectId,
  ) {
    // TODO: implement getWorkItemAttributes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<WorkTypeEntity>>> getWorkTypes(String projectId) {
    // TODO: implement getWorkTypes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> reorderWorkTypes(List<String> orderedIds) {
    // TODO: implement reorderWorkTypes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TimeTrackingConfigEntity>> saveTimeTrackingConfig(
    TimeTrackingConfigEntity config,
  ) {
    // TODO: implement saveTimeTrackingConfig
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkItemAttributeValueEntity>> updateAttributeValue({
    required WorkItemAttributeValueEntity value,
  }) {
    // TODO: implement updateAttributeValue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CustomWorkItemAttributeEntity>> updateCustomAttribute({
    required String attributeId,
    String? name,
    String? fieldType,
    bool? isRequired,
    List<String>? options,
  }) {
    // TODO: implement updateCustomAttribute
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkItemAttributeEntity>> updateWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  }) {
    // TODO: implement updateWorkItemAttribute
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkTypeEntity>> updateWorkType({
    required String workTypeId,
    String? name,
    String? description,
    bool? isActive,
  }) {
    // TODO: implement updateWorkType
    throw UnimplementedError();
  }
}
