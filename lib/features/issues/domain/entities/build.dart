import 'package:equatable/equatable.dart';

class Build extends Equatable {
  final String id;
  final String name;
  final DateTime? date;
  final String? projectId;

  const Build({
    required this.id,
    required this.name,
    this.date,
    this.projectId,
  });

  @override
  List<Object?> get props => [id, name, date, projectId];

  Build copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? projectId,
  }) {
    return Build(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      projectId: projectId ?? this.projectId,
    );
  }
}
