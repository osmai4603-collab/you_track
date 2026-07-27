import '../../domain/entities/time_tracking_config_entity.dart';

class TimeTrackingConfigModel extends TimeTrackingConfigEntity {
  const TimeTrackingConfigModel({
    required super.projectId,
    super.enabled,
    super.estimationFieldId,
    super.spentTimeFieldId,
    super.aggregateSpentTime,
    super.aggregateEstimation,
    required super.updatedAt,
  });

  factory TimeTrackingConfigModel.fromEntity(TimeTrackingConfigEntity entity) {
    return TimeTrackingConfigModel(
      projectId: entity.projectId,
      enabled: entity.enabled,
      estimationFieldId: entity.estimationFieldId,
      spentTimeFieldId: entity.spentTimeFieldId,
      aggregateSpentTime: entity.aggregateSpentTime,
      aggregateEstimation: entity.aggregateEstimation,
      updatedAt: entity.updatedAt,
    );
  }

  factory TimeTrackingConfigModel.fromJson(Map<String, dynamic> json) {
    return TimeTrackingConfigModel(
      projectId: (json['project_id'] ?? '').toString(),
      enabled: json['enabled'] as bool? ?? false,
      estimationFieldId: json['estimation_field_id']?.toString(),
      spentTimeFieldId: json['spent_time_field_id']?.toString(),
      aggregateSpentTime: json['aggregate_spent_time'] as bool? ?? false,
      aggregateEstimation: json['aggregate_estimation'] as bool? ?? false,
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'enabled': enabled,
      'estimation_field_id': estimationFieldId,
      'spent_time_field_id': spentTimeFieldId,
      'aggregate_spent_time': aggregateSpentTime,
      'aggregate_estimation': aggregateEstimation,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
