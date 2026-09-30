import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/knowledge_base/domain/entities/article.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  @override
  Future<Either<Failure, Article>> createArticle(Article article) {
    // TODO: implement createArticle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteArticle(String articleId) {
    // TODO: implement deleteArticle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Article>> getArticleById(String articleId) {
    // TODO: implement getArticleById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Article>>> getArticleTree({String? projectId}) {
    // TODO: implement getArticleTree
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> publishArticle(String articleId) {
    // TODO: implement publishArticle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> reorderArticles(List<Article> articles) {
    // TODO: implement reorderArticles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(
    String projectId,
    String query,
  ) {
    // TODO: implement searchArticles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Article>> updateArticle(Article article) {
    // TODO: implement updateArticle
    throw UnimplementedError();
  }
}
