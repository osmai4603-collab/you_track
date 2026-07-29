/// ثوابت مفاتيح مسارات التنقل في التطبيق.
///
/// يتم استدعاء هذه الثوابت من [NavigationService] و الـ UI
/// لضمان عدم تكرار النصوص (Hardcoded Strings).
sealed class AppRouteKeys {
  const AppRouteKeys._();

  // ── Auth Branch ───────────────────────────────────
  static const String login = '/login';

  // ── Main Dashboard Branch ───────────────────────────────────
  static const String dashboard = '/dashboard';
  static const String issues = '/issues';
  static const String createIssue = '/issues/new-issue';
  static const String board = '/board';
  static const String notifications = '/notifications';
  static const String agileBoards = '/agile-boards';
  static const String reports = '/reports';

  // ── Projects Branch ───────────────────────────────────
  static const String projects = '/projects';
  static const String projectTemplates = '$projects/templates';
  static const String createProject = '$projects/new';

  static const String knowldgeBase = '/knowldge-base';

  static const String groups = '/groups';
  static const String createGroup = '$groups/new';

  static const String roles = '/roles';
  static const String createRole = '$roles/new';

  static const String users = '/users';
  static const String createUser = '$users/new';

  static const String timeSheets = '/time-sheets';

  static const whiteBoards = '/white-boards';

  static const ganttChart = '/gantt-chart';

  // ── Dynamic Path Builders ───────────────────────────────────
  static String templateDetailsPath(String templateId) =>
      '$projects/templates/$templateId';

  static String projectDetailsPath(String projectId) {
    return '$projects/$projectId';
  }

  static String projectIssuesPath(String projectId) {
    return '$projects/$projectId/issues';
  }

  static String projectAgileBoardsPath(String projectId) {
    return '$projects/$projectId/agile-boards';
  }

  static String projectGanttChartPath(String projectId) {
    return '$projects/$projectId/gantt-chart';
  }

  static String projectSettingsWorkflows(String projectId) {
    return projectSettingsSectionPath(projectId, 'workflows');
  }

  static String projectSettingsTimeTracking(String projectId) {
    return projectSettingsSectionPath(projectId, 'time-tracking');
  }

  static String projectSettingsPeople(String projectId) {
    return projectSettingsSectionPath(projectId, 'people');
  }

  static String projectSettingsNotifications(String projectId) {
    return projectSettingsSectionPath(projectId, 'notifications');
  }

  static String projectSettingsCustomFields(String projectId) {
    return projectSettingsSectionPath(projectId, 'custom-fields');
  }

  static String projectSettingsGeneral(String projectId) {
    return projectSettingsSectionPath(projectId, 'general');
  }

  static String projectSettingsVersionControl(String projectId) {
    return projectSettingsSectionPath(projectId, 'vcs');
  }

  static String projectSettingsApps(String projectId) {
    return projectSettingsSectionPath(projectId, 'apps');
  }

  static String projectSettingsBuildServers(String projectId) {
    return projectSettingsSectionPath(projectId, 'builds');
  }

  static String projectSettingsPath(String projectId) {
    return '$projects/$projectId/settings';
  }

  static String projectSettingsSectionPath(String projectId, String section) {
    return '${projectSettingsPath(projectId)}/$section';
  }

  static String projectKnowledgeBasePath(String projectId) {
    return '$projects/$projectId/knowledge-base';
  }

  static String projectKnowledgeBaseArticlePath(
    String projectId,
    String articleId,
  ) {
    return '$projects/$projectId/knowledge-base/$articleId';
  }

  static String projectVersionControlChanges(String projectId) {
    return 'projects/$projectId/vc-changes';
  }

  static String projectTimeTrackingPath(String projectId) {
    return '$projects/$projectId/time-tracking';
  }
}
