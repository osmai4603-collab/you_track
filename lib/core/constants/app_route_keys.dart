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
  static const String projects = '/projects';
  static const String agileBoards = '/agile-boards';
  static const String projectTemplates = '/projects/templates';
  static const String templateDetails = '/projects/templates/details';
  static const String createProject = '/projects/new';
  static const String addProjectMembers = '/projects/add-members';
  static const String projectDetails = '/projects/details';
  static const String projectMembers = '/projects/members';
  static const String issues = '/issues';
  static const String board = '/board';
  static const String notifications = '/notifications';

  static const String reports = '/reports';
}
