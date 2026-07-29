import '../../domain/entities/article_comment.dart';

class ArticleCommentModel extends ArticleComment {
  const ArticleCommentModel({
    required super.id,
    required super.articleId,
    required super.authorId,
    required super.commentText,
    required super.anchorText,
    required super.anchorStart,
    required super.anchorEnd,
    super.isResolved,
    super.resolvedBy,
    super.resolvedAt,
    required super.createdAt,
  });

  factory ArticleCommentModel.fromJson(Map<String, dynamic> json) {
    return ArticleCommentModel(
      id: (json['id'] ?? '').toString(),
      articleId: (json['article_id'] ?? '').toString(),
      authorId: (json['author_id'] ?? '').toString(),
      commentText: (json['comment_text'] ?? '').toString(),
      anchorText: (json['anchor_text'] ?? '').toString(),
      anchorStart: (json['anchor_start'] ?? 0) as int,
      anchorEnd: (json['anchor_end'] ?? 0) as int,
      isResolved: json['is_resolved'] == true,
      resolvedBy: json['resolved_by']?.toString(),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'].toString())
          : null,
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'article_id': articleId,
      'author_id': authorId,
      'comment_text': commentText,
      'anchor_text': anchorText,
      'anchor_start': anchorStart,
      'anchor_end': anchorEnd,
      'is_resolved': isResolved,
      'resolved_by': resolvedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
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
}
