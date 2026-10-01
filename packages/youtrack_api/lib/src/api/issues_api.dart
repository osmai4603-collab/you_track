import 'dart:typed_data';

import 'package:youtrack_api/src/models/issue_model.dart';
import 'package:youtrack_api/src/network/network_api.dart';
import 'package:youtrack_api/src/network/network_result.dart';
import 'json_api.dart';

/// Issue CRUD, search, sprint/build metadata, and attachment endpoints.
class IssuesApi {
  final NetworkAPI _api;
  const IssuesApi(this._api);

  /// `GET /issues` — every issue the current identity may read.
  Future<ApiResult<List<IssueModel>>> getIssues({
    Map<String, dynamic>? queryParameters,
  }) {
    return _api.getList(
      endpoint: '/issues',
      queryParameters: queryParameters,
      fromJson: IssueModel.fromJson,
    );
  }

  /// `GET /issues/{issueID}` — a single issue.
  Future<ApiResult<IssueModel>> getIssueByID(String issueID) {
    return _api.get(
      endpoint: '/issues/${Uri.encodeComponent(issueID)}',
      fromJson: IssueModel.fromJson,
    );
  }

  /// `GET /projects/{projectID}/issues` — the issues of one project.
  Future<ApiResult<List<IssueModel>>> getProjectIssues(
    String projectID, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _api.getList(
      endpoint: '/projects/${Uri.encodeComponent(projectID)}/issues',
      queryParameters: queryParameters,
      fromJson: IssueModel.fromJson,
    );
  }

  /// `POST /issues` — creates an issue from the app's complete issue payload.
  Future<ApiResult<JsonObject>> createIssue(JsonObject issue) {
    return JsonApi(_api).postObject('/issues', data: issue);
  }

  /// `PUT /issues/{issueID}` — replaces the editable issue fields.
  Future<ApiResult<JsonObject>> updateIssue(String issueID, JsonObject issue) {
    return JsonApi(
      _api,
    ).putObject('/issues/${Uri.encodeComponent(issueID)}', data: issue);
  }

  /// `DELETE /issues/{issueID}`.
  Future<ApiResult<void>> deleteIssue(String issueID) {
    return JsonApi(_api).deleteVoid('/issues/${Uri.encodeComponent(issueID)}');
  }

  /// `PUT /issues/{issueID}/starred`.
  Future<ApiResult<void>> setStarred(String issueID, bool starred) {
    return JsonApi(_api).putVoid(
      '/issues/${Uri.encodeComponent(issueID)}/starred',
      data: <String, dynamic>{'starred': starred},
    );
  }

  /// `GET /projects/{projectID}/builds`.
  Future<ApiResult<List<JsonObject>>> getBuilds(String projectID) {
    return JsonApi(
      _api,
    ).getObjects('/projects/${Uri.encodeComponent(projectID)}/builds');
  }

  /// `POST /projects/{projectID}/builds`.
  Future<ApiResult<JsonObject>> createBuild(
    String projectID,
    JsonObject build,
  ) {
    return JsonApi(_api).postObject(
      '/projects/${Uri.encodeComponent(projectID)}/builds',
      data: build,
    );
  }

  /// `GET /projects/{projectID}/sprints`.
  Future<ApiResult<List<JsonObject>>> getSprints(String projectID) {
    return JsonApi(
      _api,
    ).getObjects('/projects/${Uri.encodeComponent(projectID)}/sprints');
  }

  /// `GET /issues/{issueID}/attachments`.
  Future<ApiResult<List<JsonObject>>> getAttachments(String issueID) {
    return JsonApi(
      _api,
    ).getObjects('/issues/${Uri.encodeComponent(issueID)}/attachments');
  }

  /// `POST /issues/{issueID}/attachments` as a multipart file upload.
  Future<ApiResult<JsonObject>> uploadAttachment(
    String issueID, {
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    return _api.uploadFile(
      endpoint: '/issues/${Uri.encodeComponent(issueID)}/attachments',
      filePath: filePath,
      fileName: fileName,
      onProgress: onProgress,
    );
  }

  /// `GET /issues/{issueID}/attachments/download?storagePath=...`.
  Future<ApiResult<Uint8List>> downloadAttachment(
    String issueID, {
    required String storagePath,
  }) {
    return _api.downloadFile(
      endpoint: '/issues/${Uri.encodeComponent(issueID)}/attachments/download',
      queryParameters: {'storagePath': storagePath},
    );
  }

  /// `DELETE /issues/{issueID}/attachments?storagePath=...`.
  Future<ApiResult<void>> deleteAttachment(
    String issueID, {
    required String storagePath,
  }) {
    return JsonApi(_api).deleteVoid(
      '/issues/${Uri.encodeComponent(issueID)}/attachments',
      queryParameters: {'storagePath': storagePath},
    );
  }
}
