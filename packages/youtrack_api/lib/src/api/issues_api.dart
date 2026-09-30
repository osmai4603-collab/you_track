import 'package:youtrack_api/src/models/issue_model.dart';
import 'package:youtrack_api/src/network/network_api.dart';
import 'package:youtrack_api/src/network/network_result.dart';

/// The read endpoints for issues.
///
/// Only the three reads are implemented. Every write in this area needs a custom
/// field representation the server does not expose yet, so a half-built
/// `createIssue` would be worse than none: it would accept a call, appear to
/// work, and silently drop the state, priority and type the user picked.
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
}
