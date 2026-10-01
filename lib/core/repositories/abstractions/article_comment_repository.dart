import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';

abstract class ArticleCommentRepository {
  Future<Either<Failure, List<ArticleComment>>> getComments(String articleId);
  Future<Either<Failure, ArticleComment>> addComment(ArticleComment comment);
  Future<Either<Failure, void>> resolveComment(
    String commentId,
    String resolvedBy,
  );
  Future<Either<Failure, void>> deleteComment(String commentId);
}
