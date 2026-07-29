import '../../domain/entities/sprint.dart';

class SprintModel extends Sprint {
  const SprintModel({
    required super.id,
    required super.name,
    super.startDate,
    super.releaseDate,
    super.isReleased,
    super.description,
    super.color,
    super.projectId,
  });

  factory SprintModel.fromJson(Map<String, dynamic> json) {
    return SprintModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'].toString())
          : null,
      releaseDate: json['release_date'] != null
          ? DateTime.parse(json['release_date'].toString())
          : null,
      isReleased: json['is_released'] == true,
      description: (json['description'] ?? '').toString(),
      color: (json['color'] ?? 0) as int,
      projectId: json['project_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate?.toIso8601String(),
      'release_date': releaseDate?.toIso8601String(),
      'is_released': isReleased,
      'description': description,
      'color': color,
      'project_id': projectId,
    };
  }
}
