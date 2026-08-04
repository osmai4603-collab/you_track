import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/models/article_model.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Article>>> getArticleTree({
    String? projectId,
  }) async {
    try {
      final articles = await remoteDataSource.getArticleTree(
        projectId: projectId,
      );
      return Right(articles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> getArticleById(String articleId) async {
    try {
      final article = await remoteDataSource.getArticleById(articleId);
      return Right(article);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> createArticle(Article article) async {
    try {
      final model = ArticleModel(
        id: '',
        projectId: article.projectId,
        parentId: article.parentId,
        title: article.title,
        contentMarkdown: article.contentMarkdown,
        status: article.status,
        visibility: article.visibility,
        sortOrder: article.sortOrder,
        createdBy: article.createdBy,
        createdAt: article.createdAt,
        updatedAt: article.updatedAt,
      );
      final result = await remoteDataSource.createArticle(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> updateArticle(Article article) async {
    try {
      final model = ArticleModel(
        id: article.id,
        projectId: article.projectId,
        parentId: article.parentId,
        title: article.title,
        contentMarkdown: article.contentMarkdown,
        status: article.status,
        visibility: article.visibility,
        sortOrder: article.sortOrder,
        createdBy: article.createdBy,
        createdAt: article.createdAt,
        updatedAt: DateTime.now(),
      );
      final result = await remoteDataSource.updateArticle(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> publishArticle(String articleId) async {
    try {
      final article = await remoteDataSource.getArticleById(articleId);
      await remoteDataSource.updateArticle(
        ArticleModel.fromEntity(article.copyWith(status: 'published')),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteArticle(String articleId) async {
    try {
      await remoteDataSource.deleteArticle(articleId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reorderArticles(List<Article> articles) async {
    try {
      for (final article in articles) {
        final model = ArticleModel(
          id: article.id,
          projectId: article.projectId,
          parentId: article.parentId,
          title: article.title,
          contentMarkdown: article.contentMarkdown,
          status: article.status,
          visibility: article.visibility,
          sortOrder: article.sortOrder,
          createdBy: article.createdBy,
          createdAt: article.createdAt,
          updatedAt: DateTime.now(),
        );
        await remoteDataSource.updateArticle(model);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(
    String projectId,
    String query,
  ) async {
    try {
      final articles = await remoteDataSource.searchArticles(projectId, query);
      return Right(articles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
