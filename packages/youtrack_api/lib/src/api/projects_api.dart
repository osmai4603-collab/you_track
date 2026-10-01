import '../models/project_member_model.dart';
import '../models/project_model.dart';
import '../network/network_api.dart';
import '../network/network_result.dart';
import 'json_api.dart';

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
      endpoint: '/projects/${Uri.encodeComponent(projectID)}',
      fromJson: ProjectModel.fromJson,
    );
    return result;
  }

  Future<ApiResult<List<ProjectMemberModel>>> getMembers(
    String projectID,
  ) async {
    final result = await _api.getList(
      endpoint: '/projects/${Uri.encodeComponent(projectID)}/members',
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
      data: model.toJson(),
      fromJson: ProjectModel.fromJson,
    );
    return result;
  }

  Future<ApiResult<ProjectModel>> updateProject(
    String projectID,
    ProjectModel model,
  ) {
    return JsonApi(_api)
        .patchObject(
          '/projects/${Uri.encodeComponent(projectID)}',
          data: model.toJson(),
        )
        .then(_projectResult);
  }

  Future<ApiResult<void>> archiveProject(String projectID) {
    return JsonApi(
      _api,
    ).postVoid('/projects/${Uri.encodeComponent(projectID)}/archive');
  }

  Future<ApiResult<void>> deleteProject(String projectID) {
    return JsonApi(
      _api,
    ).deleteVoid('/projects/${Uri.encodeComponent(projectID)}');
  }

  Future<ApiResult<void>> setStartingNumber(
    String projectID, {
    required int startingNumber,
  }) {
    return JsonApi(_api).patchVoid(
      '/projects/${Uri.encodeComponent(projectID)}/settings',
      data: {'startingNumber': startingNumber},
    );
  }

  Future<ApiResult<ProjectMemberModel>> addMember(
    String projectID, {
    required String userID,
    List<String> roles = const [],
  }) {
    return _api.post(
      endpoint: '/projects/${Uri.encodeComponent(projectID)}/members',
      data: {'userId': userID, 'roles': roles},
      fromJson: ProjectMemberModel.fromJson,
    );
  }

  Future<ApiResult<List<JsonObject>>> getSubsystems(String projectID) {
    return JsonApi(
      _api,
    ).getObjects('/projects/${Uri.encodeComponent(projectID)}/subsystems');
  }

  Future<ApiResult<JsonObject>> getSubsystemByID(String subsystemID) {
    return JsonApi(
      _api,
    ).getObject('/subsystems/${Uri.encodeComponent(subsystemID)}');
  }

  Future<ApiResult<JsonObject>> createSubsystem(
    String projectID,
    JsonObject subsystem,
  ) {
    return JsonApi(_api).postObject(
      '/projects/${Uri.encodeComponent(projectID)}/subsystems',
      data: subsystem,
    );
  }

  Future<ApiResult<JsonObject>> addSubsystem(
    String projectID,
    JsonObject subsystem,
  ) => createSubsystem(projectID, subsystem);

  Future<ApiResult<List<JsonObject>>> getProjectTemplates() {
    return JsonApi(_api).getObjects('/projects/templates');
  }

  static ApiResult<ProjectModel> _projectResult(ApiResult<JsonObject> result) {
    if (result.isFailure) return ApiFailure(result.error);
    return ApiSuccess(ProjectModel.fromJson(result.data));
  }
}
