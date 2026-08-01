import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_value_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/time_tracking_config_entity.dart';
import '../entities/work_type_entity.dart';
import '../entities/custom_work_item_attribute_entity.dart';
import '../entities/work_item_attribute_entity.dart';

abstract class TimeTrackingRepository {
  Future<Either<Failure, TimeTrackingConfigEntity>> getTimeTrackingConfig(
    String projectId,
  );
  Future<Either<Failure, TimeTrackingConfigEntity>> saveTimeTrackingConfig(
    TimeTrackingConfigEntity config,
  );

  Future<Either<Failure, List<WorkTypeEntity>>> getWorkTypes(String projectId);
  Future<Either<Failure, WorkTypeEntity>> addWorkType({
    required String projectId,
    required String name,
    String? description,
  });
  Future<Either<Failure, WorkTypeEntity>> updateWorkType({
    required String workTypeId,
    String? name,
    String? description,
    bool? isActive,
  });
  Future<Either<Failure, void>> deleteWorkType(String workTypeId);
  Future<Either<Failure, void>> reorderWorkTypes(List<String> orderedIds);

  Future<Either<Failure, List<CustomWorkItemAttributeEntity>>>
  getCustomAttributes(String projectId);
  Future<Either<Failure, CustomWorkItemAttributeEntity>> addCustomAttribute({
    required String projectId,
    required String name,
    required String fieldType,
    bool isRequired,
    List<String>? options,
  });
  Future<Either<Failure, CustomWorkItemAttributeEntity>> updateCustomAttribute({
    required String attributeId,
    String? name,
    String? fieldType,
    bool? isRequired,
    List<String>? options,
  });
  Future<Either<Failure, void>> deleteCustomAttribute(String attributeId);

  Future<Either<Failure, List<WorkItemAttributeEntity>>> getWorkItemAttributes(
    String projectId,
  );
  Future<Either<Failure, WorkItemAttributeEntity>> addWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  });
  Future<Either<Failure, WorkItemAttributeEntity>> updateWorkItemAttribute({
    required WorkItemAttributeEntity attribute,
  });
  Future<Either<Failure, void>> deleteWorkItemAttribute(String attributeId);

  Future<Either<Failure, List<WorkItemAttributeValueEntity>>>
  getAttributeValues(String attributeId);
  Future<Either<Failure, WorkItemAttributeValueEntity>> addAttributeValue({
    required WorkItemAttributeValueEntity value,
  });
  Future<Either<Failure, WorkItemAttributeValueEntity>> updateAttributeValue({
    required WorkItemAttributeValueEntity value,
  });
  Future<Either<Failure, void>> deleteAttributeValue(String valueId);
}
