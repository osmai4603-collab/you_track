// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Issues Tracking';

  @override
  String get welcomeMessage => 'Welcome to Issues Tracking';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get submit => 'Submit';

  @override
  String get projects => 'Projects';

  @override
  String get issues => 'Issues';

  @override
  String get board => 'Board';

  @override
  String get notifications => 'Notifications';

  @override
  String get createIssue => 'Create Issue';

  @override
  String get createProject => 'Create Project';

  @override
  String get search => 'Search';
}
