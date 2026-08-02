import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';

class SubsystemEntity extends Entity {
  final String id;
  final String name;
  final String projectId;
  final String ownerId;
  final int color;
  final String firstLetter;

  const SubsystemEntity({
    required this.id,
    required this.name,
    required this.projectId,
    required this.ownerId,
    required this.color,
    required this.firstLetter,
  });

  @override
  SubsystemEntity copyWith({
    String? id,
    String? name,
    String? projectId,
    String? ownerId,
    IssueSubsystemEnum? subsystemType,
    int? color,
    String? firstLetter,
  }) {
    return SubsystemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      ownerId: ownerId ?? this.ownerId,
      color: color ?? this.color,
      firstLetter: firstLetter ?? this.firstLetter,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    projectId,
    ownerId,
    color,
    firstLetter,
  ];
}