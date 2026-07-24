// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تتبع المشاكل';

  @override
  String get welcomeMessage => 'مرحباً بك في نظام تتبع المشاكل';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'حساب جديد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get submit => 'إرسال';

  @override
  String get projects => 'المشاريع';

  @override
  String get issues => 'المشاكل والمهام';

  @override
  String get board => 'لوحة العمل';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get createIssue => 'إنشاء مشكلة';

  @override
  String get createProject => 'إنشاء مشروع';

  @override
  String get search => 'بحث';
}
