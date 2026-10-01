import 'package:youtrack_api/src/models/board_model.dart';
import 'package:youtrack_api/src/network/network_api.dart';
import 'package:youtrack_api/src/network/network_result.dart';

class AgileBoardsApi {
  final NetworkAPI _api;
  const AgileBoardsApi(this._api);

  Future<ApiResult<AgileBoardModel>> getBoard(
    String projectID, {
    String? sprintID,
  }) {
    final hasSprint = sprintID != null && sprintID.isNotEmpty;
    return _api.get(
      endpoint: '/projects/${Uri.encodeComponent(projectID)}/board',
      queryParameters: hasSprint
          ? <String, dynamic>{'sprintID': sprintID}
          : null,
      fromJson: AgileBoardModel.fromJson,
    );
  }

  Future<ApiResult<void>> moveCard(
    String issueId, {
    required String state,
  }) async {
    return _api.post<void>(
      endpoint: '/issues/${Uri.encodeComponent(issueId)}/state',
      queryParameters: {'state': state},
      fromJson: (_) {},
    );
  }
}
