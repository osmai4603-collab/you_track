import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/article_comment_repository.dart';

class ArticleCommentRepositoryImpl implements ArticleCommentRepository {
  @override
  Future<Either<Failure, ArticleComment>> addComment(ArticleComment comment) {
    // TODO: implement addComment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ArticleComment>>> getComments(String articleId) {
    // TODO: implement getComments
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> resolveComment(
    String commentId,
    String resolvedBy,
  ) {
    // TODO: implement resolveComment
    throw UnimplementedError();
  }
}
