import 'package:issues_tracking/core/entities/entity.dart';

class SavedSearchEntity extends Entity {
  final String id;
  final String userId;
  final String name;
  final String query;
  final bool isFavorite;
  final DateTime? createdAt;

  const SavedSearchEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.query,
    this.isFavorite = false,
    this.createdAt,
  });

  @override
  SavedSearchEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? query,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return SavedSearchEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      query: query ?? this.query,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, query, isFavorite, createdAt];
}