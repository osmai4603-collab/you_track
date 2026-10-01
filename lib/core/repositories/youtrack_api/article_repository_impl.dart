import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';
import 'package:issues_tracking/core/repositories/abstractions/article_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticlesApi _api;

  ArticleRepositoryImpl(this._api);

  @override
  Future<Either<Failure, Article>> createArticle(Article article) async {
    final result = await _api.createArticle(_articleToJson(article));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_articleFromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteArticle(String articleId) async {
    final result = await _api.deleteArticle(articleId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, Article>> getArticleById(String articleId) async {
    final result = await _api.getArticle(articleId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_articleFromJson(result.data));
  }

  @override
  Future<Either<Failure, List<Article>>> getArticleTree({
    String? projectId,
  }) async {
    final result = await _api.getTree(projectID: projectId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_articleFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, void>> publishArticle(String articleId) async {
    final result = await _api.publishArticle(articleId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> reorderArticles(List<Article> articles) async {
    final result = await _api.reorderArticles(
      articles.map(_articleToJson).toList(growable: false),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(
    String projectId,
    String query,
  ) async {
    final result = await _api.searchArticles(
      projectID: projectId,
      query: query,
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_articleFromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, Article>> updateArticle(Article article) async {
    final result = await _api.updateArticle(
      article.id,
      _articleToJson(article),
    );
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_articleFromJson(result.data));
  }
}

Article _articleFromJson(JsonObject json) => Article(
  id: _text(json, 'id'),
  projectId: _text(json, 'projectId', alias: 'project_id'),
  parentId: _optionalText(json, 'parentId', alias: 'parent_id'),
  title: _text(json, 'title'),
  contentMarkdown: _text(json, 'contentMarkdown', alias: 'content_markdown'),
  status: _text(json, 'status', fallback: 'draft'),
  visibility: json['visibility'] is List
      ? (json['visibility'] as List).map((value) => value.toString()).toList()
      : const ['admin', 'developer', 'visitor'],
  sortOrder:
      int.tryParse((json['sortOrder'] ?? json['sort_order'] ?? 0).toString()) ??
      0,
  createdBy: _text(json, 'createdBy', alias: 'created_by'),
  createdAt: _date(json['createdAt'] ?? json['created_at']),
  updatedAt: _date(json['updatedAt'] ?? json['updated_at']),
);

JsonObject _articleToJson(Article article) => {
  'id': article.id,
  'projectId': article.projectId,
  'parentId': article.parentId,
  'title': article.title,
  'contentMarkdown': article.contentMarkdown,
  'status': article.status,
  'visibility': article.visibility,
  'sortOrder': article.sortOrder,
  'createdBy': article.createdBy,
};

String _text(
  JsonObject json,
  String key, {
  String? alias,
  String fallback = '',
}) =>
    (json[key] ?? (alias == null ? null : json[alias]) ?? fallback).toString();

String? _optionalText(JsonObject json, String key, {String? alias}) {
  final value = json[key] ?? (alias == null ? null : json[alias]);
  return value?.toString();
}

DateTime _date(Object? value) {
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
