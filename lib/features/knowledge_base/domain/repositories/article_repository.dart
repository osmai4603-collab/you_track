import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticleTree(String projectId);
  Future<Either<Failure, Article>> getArticleById(String articleId);
  Future<Either<Failure, Article>> createArticle(Article article);
  Future<Either<Failure, Article>> updateArticle(Article article);
  Future<Either<Failure, void>> publishArticle(String articleId);
  Future<Either<Failure, void>> deleteArticle(String articleId);
  Future<Either<Failure, void>> reorderArticles(List<Article> articles);
  Future<Either<Failure, List<Article>>> searchArticles(
    String projectId,
    String query,
  );
}
