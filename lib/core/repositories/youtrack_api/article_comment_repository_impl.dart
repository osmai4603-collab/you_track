import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/core/repositories/abstractions/article_comment_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class ArticleCommentRepositoryImpl implements ArticleCommentRepository {
  final ArticleCommentsApi _api;

  ArticleCommentRepositoryImpl(this._api);

  @override
  Future<Either<Failure, ArticleComment>> addComment(
    ArticleComment comment,
  ) async {
    final result = await _api.addComment(_commentToJson(comment));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_commentFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    final result = await _api.deleteComment(commentId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<ArticleComment>>> getComments(
    String articleId,
  ) async {
    final result = await _api.getComments(articleId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_commentFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> resolveComment(
    String commentId,
    String resolvedBy,
  ) async {
    final result = await _api.resolveComment(commentId, resolvedBy);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }
}

ArticleComment _commentFromJson(JsonObject json) => ArticleComment(
  id: (json['id'] ?? '').toString(),
  articleId: (json['articleId'] ?? json['article_id'] ?? '').toString(),
  authorId: (json['authorId'] ?? json['author_id'] ?? '').toString(),
  commentText: (json['commentText'] ?? json['comment_text'] ?? '').toString(),
  anchorText: (json['anchorText'] ?? json['anchor_text'] ?? '').toString(),
  anchorStart:
      int.tryParse(
        (json['anchorStart'] ?? json['anchor_start'] ?? 0).toString(),
      ) ??
      0,
  anchorEnd:
      int.tryParse((json['anchorEnd'] ?? json['anchor_end'] ?? 0).toString()) ??
      0,
  isResolved: json['isResolved'] == true || json['is_resolved'] == true,
  resolvedBy: (json['resolvedBy'] ?? json['resolved_by'])?.toString(),
  resolvedAt: _date(json['resolvedAt'] ?? json['resolved_at']),
  createdAt:
      _date(json['createdAt'] ?? json['created_at']) ??
      DateTime.fromMillisecondsSinceEpoch(0),
);

JsonObject _commentToJson(ArticleComment comment) => {
  'id': comment.id,
  'articleId': comment.articleId,
  'authorId': comment.authorId,
  'commentText': comment.commentText,
  'anchorText': comment.anchorText,
  'anchorStart': comment.anchorStart,
  'anchorEnd': comment.anchorEnd,
};

DateTime? _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '');
}
