import 'package:equatable/equatable.dart';

class Sprint extends Equatable {
  final String id;
  final String name;
  final DateTime? startDate;
  final DateTime? releaseDate;
  final bool isReleased;
  final String description;
  final int color;
  final String? projectId;

  const Sprint({
    required this.id,
    required this.name,
    this.startDate,
    this.releaseDate,
    this.isReleased = false,
    this.description = '',
    this.color = 0,
    this.projectId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        startDate,
        releaseDate,
        isReleased,
        description,
        color,
        projectId,
      ];

  Sprint copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? releaseDate,
    bool? isReleased,
    String? description,
    int? color,
    String? projectId,
  }) {
    return Sprint(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      releaseDate: releaseDate ?? this.releaseDate,
      isReleased: isReleased ?? this.isReleased,
      description: description ?? this.description,
      color: color ?? this.color,
      projectId: projectId ?? this.projectId,
    );
  }
}
