import '../../../../core/entities/entity.dart';

class TimeTrackingConfigEntity extends Entity {
  final String projectId;
  final bool enabled;
  final String? estimationFieldId;
  final String? spentTimeFieldId;
  final bool aggregateSpentTime;
  final bool aggregateEstimation;
  final DateTime updatedAt;

  const TimeTrackingConfigEntity({
    required this.projectId,
    this.enabled = false,
    this.estimationFieldId,
    this.spentTimeFieldId,
    this.aggregateSpentTime = false,
    this.aggregateEstimation = false,
    required this.updatedAt,
  });

  @override
  TimeTrackingConfigEntity copyWith({
    String? projectKey,
    bool? enabled,
    String? estimationFieldId,
    String? spentTimeFieldId,
    bool? aggregateSpentTime,
    bool? aggregateEstimation,
    DateTime? updatedAt,
  }) {
    return TimeTrackingConfigEntity(
      projectId: projectKey ?? this.projectId,
      enabled: enabled ?? this.enabled,
      estimationFieldId: estimationFieldId ?? this.estimationFieldId,
      spentTimeFieldId: spentTimeFieldId ?? this.spentTimeFieldId,
      aggregateSpentTime: aggregateSpentTime ?? this.aggregateSpentTime,
      aggregateEstimation: aggregateEstimation ?? this.aggregateEstimation,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    projectId,
    enabled,
    estimationFieldId,
    spentTimeFieldId,
    aggregateSpentTime,
    aggregateEstimation,
    updatedAt,
  ];
}
