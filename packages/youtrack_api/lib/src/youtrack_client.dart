import 'package:youtrack_api/src/api/agile_boards_api.dart';
import 'package:youtrack_api/src/api/custom_fields_api.dart';
import 'package:youtrack_api/src/api/dashboards_api.dart';
import 'package:youtrack_api/src/api/groups_api.dart';
import 'package:youtrack_api/src/api/issues_api.dart';
import 'package:youtrack_api/src/api/knowledge_base_api.dart';
import 'package:youtrack_api/src/api/projects_api.dart';
import 'package:youtrack_api/src/api/roles_api.dart';
import 'package:youtrack_api/src/api/tags_api.dart';
import 'package:youtrack_api/src/api/time_tracking_api.dart';
import 'package:youtrack_api/src/api/user_profile_api.dart';
import 'package:youtrack_api/src/api/users_api.dart';
import 'package:youtrack_api/src/api/version_control_api.dart';
import 'package:youtrack_api/src/models/user_auth.dart';
import 'network/network_api.dart';
import 'network/network_result.dart';

class YoutrackClient {
  final NetworkAPI _api;
  late final UsersApi users;
  late final ProjectsApi projects;
  late final IssuesApi issues;
  late final AgileBoardsApi boards;
  late final TagsApi tags;
  late final GroupsApi groups;
  late final RolesApi roles;
  late final CustomFieldsApi customFields;
  late final DashboardsApi dashboards;
  late final ArticlesApi articles;
  late final ArticleCommentsApi articleComments;
  late final ArticleNotificationsApi articleNotifications;
  late final TimeTrackingApi timeTracking;
  late final UserProfileApi userProfile;
  late final VersionControlApi versionControl;

  YoutrackClient(this._api);

  bool _hasInitBefore = false;
  Future<void> init() async {
    if (_hasInitBefore) {
      throw Exception('Can not init youtrack client apis twice.');
    }
    users = UsersApi(_api);
    projects = ProjectsApi(_api);
    issues = IssuesApi(_api);
    boards = AgileBoardsApi(_api);
    tags = TagsApi(_api);
    groups = GroupsApi(_api);
    roles = RolesApi(_api);
    customFields = CustomFieldsApi(_api);
    dashboards = DashboardsApi(_api);
    articles = ArticlesApi(_api);
    articleComments = ArticleCommentsApi(_api);
    articleNotifications = ArticleNotificationsApi(_api);
    timeTracking = TimeTrackingApi(_api);
    userProfile = UserProfileApi(_api);
    versionControl = VersionControlApi(_api);
    _hasInitBefore = true;
  }

  Future<ApiResult<UserAuth>> login(String username, String password) async {
    final result = await _api.post(
      endpoint: '/auth/login',
      data: {'username': username, 'password': password},
      fromJson: UserAuth.fromJson,
    );
    if (result.isSuccess) {
      await _api.onLogin(result.data);
    }
    return result;
  }

  Future<ApiResult<bool>> logout() async {
    final result = await _api.post(
      endpoint: '/auth/logout',
      fromJson: (data) => data['logout'] == true,
    );
    if (result.isSuccess) {
      await _api.onLogout();
    }
    return result;
  }

  Future<ApiResult<UserAuth>> refreshToken() async {
    final result = await _api.post(
      endpoint: '/auth/refresh',
      fromJson: UserAuth.fromJson,
    );
    if (result.isSuccess) {
      await _api.onRefreshToken(result.data);
    }
    return result;
  }
}
