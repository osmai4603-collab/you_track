import '../models/project_member_model.dart';
import '../models/project_model.dart';
import '../network/network_api.dart';
import '../network/network_result.dart';

class ProjectsApi {
  final NetworkAPI _api;
  ProjectsApi(this._api);

  Future<ApiResult<List<ProjectModel>>> getProjects() async {
    final result = await _api.getList(
      endpoint: '/projects/me',
      fromJson: ProjectModel.fromJson,
    );

    return result;
  }

  Future<ApiResult<ProjectModel>> getProjectByID(String projectID) async {
    final result = await _api.get(
      endpoint: '/projects/$projectID',
      fromJson: ProjectModel.fromJson,
    );
    return result;
  }

  Future<ApiResult<List<ProjectMemberModel>>> getMembers(
    String projectID,
  ) async {
    final result = await _api.getList(
      endpoint: '/projects/$projectID/members',
      fromJson: ProjectMemberModel.fromJson,
    );
    return result;
  }

  Future<ApiResult<bool>> setFavorite(
    String projectId, {
    required bool favorite,
  }) async {
    final result = await _api.put<bool>(
      endpoint: '/projects/${Uri.encodeComponent(projectId)}/favorite',
      data: <String, dynamic>{'favorite': favorite},
      fromJson: (json) =>
          json['favorite'] is bool ? json['favorite'] as bool : favorite,
    );

    return result;
  }

  Future<ApiResult<ProjectModel>> createProject(ProjectModel model) async {
    final result = await _api.post(
      endpoint: '/projects',
      queryParameters: model.toJson(),
      fromJson: ProjectModel.fromJson,
    );
    return result;
  }
}
