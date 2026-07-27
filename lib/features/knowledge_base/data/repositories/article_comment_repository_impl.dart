import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_comment.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_comment_repository.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_comment_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/models/article_comment_model.dart';

class ArticleCommentRepositoryImpl implements ArticleCommentRepository {
  final ArticleCommentRemoteDataSource remoteDataSource;

  ArticleCommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ArticleComment>>> getComments(
    String articleId,
  ) async {
    try {
      final comments = await remoteDataSource.getComments(articleId);
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleComment>> addComment(
    ArticleComment comment,
  ) async {
    try {
      final model = ArticleCommentModel(
        id: '',
        articleId: comment.articleId,
        authorId: comment.authorId,
        commentText: comment.commentText,
        anchorText: comment.anchorText,
        anchorStart: comment.anchorStart,
        anchorEnd: comment.anchorEnd,
        createdAt: comment.createdAt,
      );
      final result = await remoteDataSource.addComment(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveComment(
    String commentId,
    String resolvedBy,
  ) async {
    try {
      await remoteDataSource.resolveComment(commentId, resolvedBy);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
