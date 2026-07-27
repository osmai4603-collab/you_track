import '../../../../core/entities/entity.dart';

class TimeEntryEntity extends Entity {
  final String id;
  final String taskId;
  final String userId;
  final String? workTypeId;
  final int durationMinutes;
  final DateTime date;
  final String? comment;
  final Map<String, dynamic>? customAttributeValues;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimeEntryEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    this.workTypeId,
    required this.durationMinutes,
    required this.date,
    this.comment,
    this.customAttributeValues,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  TimeEntryEntity copyWith({
    String? id,
    String? taskId,
    String? userId,
    String? workTypeId,
    int? durationMinutes,
    DateTime? date,
    String? comment,
    Map<String, dynamic>? customAttributeValues,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeEntryEntity(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      workTypeId: workTypeId ?? this.workTypeId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      date: date ?? this.date,
      comment: comment ?? this.comment,
      customAttributeValues: customAttributeValues ?? this.customAttributeValues,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, taskId, userId, workTypeId, durationMinutes, date,
        comment, customAttributeValues, createdAt, updatedAt,
      ];
}
