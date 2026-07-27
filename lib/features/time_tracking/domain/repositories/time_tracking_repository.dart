import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/time_tracking_config_entity.dart';
import '../entities/work_type_entity.dart';
import '../entities/custom_work_item_attribute_entity.dart';

abstract class TimeTrackingRepository {
  Future<Either<Failure, TimeTrackingConfigEntity>> getTimeTrackingConfig(String projectId);
  Future<Either<Failure, TimeTrackingConfigEntity>> saveTimeTrackingConfig(TimeTrackingConfigEntity config);

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

  Future<Either<Failure, List<CustomWorkItemAttributeEntity>>> getCustomAttributes(String projectId);
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
}
