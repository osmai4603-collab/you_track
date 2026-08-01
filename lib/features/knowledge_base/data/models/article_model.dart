import '../../domain/entities/article.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.projectId,
    super.parentId,
    required super.title,
    super.contentMarkdown,
    super.status,
    super.visibility,
    super.sortOrder,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Article', data: json);
    return ArticleModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      parentId: json['parent_id']?.toString(),
      title: (json['title'] ?? '').toString(),
      contentMarkdown: (json['content_markdown'] ?? '').toString(),
      status: (json['status'] ?? 'draft').toString(),
      visibility: _parseList(json['visibility']),
      sortOrder: (json['sort_order'] ?? 0) as int,
      createdBy: (json['created_by'] ?? '').toString(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'parent_id': parentId,
      'title': title,
      'content_markdown': contentMarkdown,
      'status': status,
      'visibility': visibility,
      'sort_order': sortOrder,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static List<String> _parseList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const ['admin', 'developer', 'visitor'];
  }

  static ArticleModel fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      projectId: article.projectId,
      createdAt: article.createdAt,
      createdBy: article.createdBy,
      contentMarkdown: article.contentMarkdown,
      updatedAt: article.updatedAt,
      parentId: article.parentId,
      title: article.title,
      sortOrder: article.sortOrder,
      status: article.status,
      visibility: article.visibility,
    );
  }
}
