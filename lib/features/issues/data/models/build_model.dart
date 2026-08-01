import '../../domain/entities/build.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class BuildModel extends Build {
  const BuildModel({
    required super.id,
    required super.name,
    super.date,
    super.projectId,
  });

  factory BuildModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Build', data: json);
    return BuildModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : null,
      projectId: json['project_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'date': date?.toIso8601String(),
      'project_id': projectId,
    };
  }
}
