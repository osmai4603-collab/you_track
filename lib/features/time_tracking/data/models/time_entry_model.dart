import '../../domain/entities/time_entry_entity.dart';

class TimeEntryModel extends TimeEntryEntity {
  const TimeEntryModel({
    required super.id,
    required super.taskId,
    required super.userId,
    super.workTypeId,
    required super.durationMinutes,
    required super.date,
    super.comment,
    super.customAttributeValues,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TimeEntryModel.fromEntity(TimeEntryEntity entity) {
    return TimeEntryModel(
      id: entity.id,
      taskId: entity.taskId,
      userId: entity.userId,
      workTypeId: entity.workTypeId,
      durationMinutes: entity.durationMinutes,
      date: entity.date,
      comment: entity.comment,
      customAttributeValues: entity.customAttributeValues,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory TimeEntryModel.fromJson(Map<String, dynamic> json) {
    return TimeEntryModel(
      id: (json['id'] ?? '').toString(),
      taskId: (json['task_id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      workTypeId: json['work_type_id']?.toString(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      date: _parseDate(json['date']),
      comment: json['comment']?.toString(),
      customAttributeValues: json['custom_attribute_values'] as Map<String, dynamic>?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'work_type_id': workTypeId,
      'duration_minutes': durationMinutes,
      'date': date.toIso8601String(),
      'comment': comment,
      'custom_attribute_values': customAttributeValues,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'task_id': taskId,
      'user_id': userId,
      'work_type_id': workTypeId,
      'duration_minutes': durationMinutes,
      'date': date.toIso8601String(),
      'comment': comment,
      'custom_attribute_values': customAttributeValues,
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
