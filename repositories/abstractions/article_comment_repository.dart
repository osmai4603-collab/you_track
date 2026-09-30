import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/knowledge_base/domain/entities/article_comment.dart';

abstract class ArticleCommentRepository {
  Future<Either<Failure, List<ArticleComment>>> getComments(String articleId);
  Future<Either<Failure, ArticleComment>> addComment(ArticleComment comment);
  Future<Either<Failure, void>> resolveComment(
    String commentId,
    String resolvedBy,
  );
  Future<Either<Failure, void>> deleteComment(String commentId);
}
