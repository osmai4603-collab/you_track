import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

class ArticlesApi {
  final JsonApi _json;

  ArticlesApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getTree({String? projectID}) =>
      _json.getObjects(
        '/articles/tree',
        queryParameters: {
          if (projectID != null && projectID.isNotEmpty) 'projectId': projectID,
        },
      );

  Future<ApiResult<JsonObject>> getArticle(String articleID) =>
      _json.getObject('/articles/${Uri.encodeComponent(articleID)}');

  Future<ApiResult<JsonObject>> createArticle(JsonObject article) =>
      _json.postObject('/articles', data: article);

  Future<ApiResult<JsonObject>> updateArticle(
    String articleID,
    JsonObject article,
  ) => _json.patchObject(
    '/articles/${Uri.encodeComponent(articleID)}',
    data: article,
  );

  Future<ApiResult<void>> publishArticle(String articleID) =>
      _json.postVoid('/articles/${Uri.encodeComponent(articleID)}/publish');

  Future<ApiResult<void>> deleteArticle(String articleID) =>
      _json.deleteVoid('/articles/${Uri.encodeComponent(articleID)}');

  Future<ApiResult<void>> reorderArticles(List<JsonObject> articles) =>
      _json.putVoid('/articles/order', data: {'articles': articles});

  Future<ApiResult<List<JsonObject>>> searchArticles({
    required String projectID,
    required String query,
  }) => _json.getObjects(
    '/articles/search',
    queryParameters: {'projectId': projectID, 'query': query},
  );
}

class ArticleCommentsApi {
  final JsonApi _json;

  ArticleCommentsApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getComments(String articleID) =>
      _json.getObjects('/articles/${Uri.encodeComponent(articleID)}/comments');

  Future<ApiResult<JsonObject>> addComment(
    JsonObject comment,
  ) => _json.postObject(
    '/articles/${Uri.encodeComponent(comment['articleId']?.toString() ?? '')}/comments',
    data: comment,
  );

  Future<ApiResult<void>> resolveComment(String commentID, String resolvedBy) =>
      _json.putVoid(
        '/article-comments/${Uri.encodeComponent(commentID)}/resolve',
        data: {'resolvedBy': resolvedBy},
      );

  Future<ApiResult<void>> deleteComment(String commentID) =>
      _json.deleteVoid('/article-comments/${Uri.encodeComponent(commentID)}');
}

class ArticleNotificationsApi {
  final JsonApi _json;

  ArticleNotificationsApi(NetworkAPI network) : _json = JsonApi(network);

  Future<ApiResult<List<JsonObject>>> getUnread(String userID) =>
      _json.getObjects(
        '/users/${Uri.encodeComponent(userID)}/notifications',
        queryParameters: const {'unread': true},
      );

  Future<ApiResult<void>> markRead(String notificationID) => _json.putVoid(
    '/article-notifications/${Uri.encodeComponent(notificationID)}/read',
  );
}
