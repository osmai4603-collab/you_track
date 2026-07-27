import 'package:issues_tracking/core/entities/entity.dart';

class ArticleComment extends Entity {
  final String id;
  final String articleId;
  final String authorId;
  final String commentText;
  final String anchorText;
  final int anchorStart;
  final int anchorEnd;
  final bool isResolved;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final DateTime createdAt;

  const ArticleComment({
    required this.id,
    required this.articleId,
    required this.authorId,
    required this.commentText,
    required this.anchorText,
    required this.anchorStart,
    required this.anchorEnd,
    this.isResolved = false,
    this.resolvedBy,
    this.resolvedAt,
    required this.createdAt,
  });

  @override
  ArticleComment copyWith({
    String? id,
    String? articleId,
    String? authorId,
    String? commentText,
    String? anchorText,
    int? anchorStart,
    int? anchorEnd,
    bool? isResolved,
    String? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
  }) {
    return ArticleComment(
      id: id ?? this.id,
      articleId: articleId ?? this.articleId,
      authorId: authorId ?? this.authorId,
      commentText: commentText ?? this.commentText,
      anchorText: anchorText ?? this.anchorText,
      anchorStart: anchorStart ?? this.anchorStart,
      anchorEnd: anchorEnd ?? this.anchorEnd,
      isResolved: isResolved ?? this.isResolved,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        articleId,
        authorId,
        commentText,
        anchorText,
        anchorStart,
        anchorEnd,
        isResolved,
        resolvedBy,
        resolvedAt,
        createdAt,
      ];
}
