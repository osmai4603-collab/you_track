/// ثوابت مفاتيح مسارات التنقل في التطبيق.
///
/// يتم استدعاء هذه الثوابت من [NavigationService] و الـ UI
/// لضمان عدم تكرار النصوص (Hardcoded Strings).
sealed class AppRouteKeys {
  const AppRouteKeys._();

  // ── Auth Branch ───────────────────────────────────
  static const String login = '/login';
  static const String register = '/register';

  // ── Main Dashboard Branch ───────────────────────────────────
  static const String dashboard = '/dashboard';
  static const String issues = '/issues';
  static const String board = '/board';
  static const String notifications = '/notifications';
  static const String agileBoards = '/agile-boards';
  static const String reports = '/reports';

  // ── Projects Branch ───────────────────────────────────
  static const String projects = '/projects';
  static const String projectTemplates = '/projects/templates';
  static const String templateDetails = '/projects/templates/:templateId';
  static const String createProject = '/projects/new';
  static const String projectDetails = '/projects/:projectId';
  static const String addProjectMembers = '/projects/:projectId/add-members';
  static const String projectMembers = '/projects/:projectId/members';

  // ── Dynamic Path Builders ───────────────────────────────────
  static String templateDetailsPath(String templateId) =>
      '/projects/templates/$templateId';

  static String projectDetailsPath(String projectId) =>
      '/projects/$projectId';

  static String addProjectMembersPath(String projectId) =>
      '/projects/$projectId/add-members';

  static String projectMembersPath(String projectId) =>
      '/projects/$projectId/members';
}
