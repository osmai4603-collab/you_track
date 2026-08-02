import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';

import '../../domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class SubsystemModel extends SubsystemEntity {
  const SubsystemModel({
    required super.id,
    required super.name,
    required super.projectId,
    required super.ownerId,
    required super.color,
    required super.firstLetter,
  });

  factory SubsystemModel.fromEntity(SubsystemEntity entity) {
    return SubsystemModel(
      id: entity.id,
      name: entity.name,
      projectId: entity.projectId,
      ownerId: entity.ownerId,
      color: entity.color,
      firstLetter: entity.firstLetter,
    );
  }

  factory SubsystemModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Subsystem', data: json);
    return SubsystemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      projectId: json['project_id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      color: (json['color'] ?? 0) as int,
      firstLetter: json['first_letter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'project_id': projectId,
      'owner_id': ownerId,
      'color': color,
      'first_letter': firstLetter,
    };
  }
}