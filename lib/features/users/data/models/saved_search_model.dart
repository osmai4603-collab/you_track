import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';

class SavedSearchModel extends SavedSearchEntity {
  const SavedSearchModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.query,
    super.isFavorite,
    super.createdAt,
  });

  factory SavedSearchModel.fromEntity(SavedSearchEntity entity) {
    return SavedSearchModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      query: entity.query,
      isFavorite: entity.isFavorite,
      createdAt: entity.createdAt,
    );
  }

  factory SavedSearchModel.fromJson(Map<String, dynamic> json) {
    return SavedSearchModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      name: json['name'] ?? '',
      query: json['query'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'query': query,
      'is_favorite': isFavorite,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'user_id': userId,
      'name': name,
      'query': query,
      'is_favorite': isFavorite,
    };
  }
}