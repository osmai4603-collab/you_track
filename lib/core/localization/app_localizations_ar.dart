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

  @override
  String get projectsTitle => 'المشاريع';

  @override
  String get filterProjectsHint => 'تصفية المشاريع حسب الاسم أو المعرف';

  @override
  String get newProjectButton => 'مشروع جديد';

  @override
  String get editProjectButton => 'تعديل';

  @override
  String get cloneProjectButton => 'نسخ';

  @override
  String get archiveProjectButton => 'أرشفة';

  @override
  String get convertToTemplateButton => 'تحويل إلى قالب';

  @override
  String get deleteProjectButton => 'حذف';

  @override
  String get selectTemplateTitle => 'مشروع جديد';

  @override
  String get defaultTemplateTitle => 'قالب المشروع الافتراضي';

  @override
  String get useThisTemplateButton => 'استخدام هذا القالب';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get projectNameLabel => 'الاسم';

  @override
  String get projectNameHint => 'أدخل اسماً لمشروعك';

  @override
  String get projectIdLabel => 'معرف المشروع';

  @override
  String get projectIdHint => 'أدخل معرف المشروع';

  @override
  String get createProjectButton => 'إنشاء مشروع';

  @override
  String get moreSettingsButton => 'إعدادات إضافية';

  @override
  String get addPeopleTitle => 'إضافة أعضاء إلى مشروعك الجديد';

  @override
  String get selectUsersHint =>
      'اختر المستخدمين والمجموعات أو أدخل البريد الإلكتروني';

  @override
  String get userLicensesLabel => 'تراخيص المستخدمين القياسية: 8';

  @override
  String get backButton => 'رجوع';

  @override
  String get nextButton => 'التالي';

  @override
  String get skipSetupButton => 'تخطي الإعداد والانتقال إلى المشروع';

  @override
  String ownedByLabel(Object owner) {
    return 'المالك: $owner';
  }

  @override
  String createdOnLabel(Object date) {
    return 'تم إنشاؤه في $date';
  }

  @override
  String get noIssuesFoundBody => 'لم يتم العثور على مشكلات';

  @override
  String get editSearchQueryButton => 'تعديل استعلام البحث';

  @override
  String get agileBoardsTitle => 'لوحات Agile';

  @override
  String get scrumBoardTitle => 'لوحة Scrum';

  @override
  String get kanbanBoardTitle => 'لوحة Kanban';

  @override
  String get versionBasedBoardTitle => 'لوحة قائمة على الإصدار';

  @override
  String get customBoardTitle => 'لوحة مخصصة';

  @override
  String get personalBoardTitle => 'لوحة شخصية';

  @override
  String get projectTeamTitle => 'فريق المشروع';

  @override
  String get otherPeopleAccessTitle => 'أشخاص آخرون لديهم إمكانية الوصول';

  @override
  String get addPeopleButton => 'إضافة أعضاء...';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get ganttCharts => 'مخططات جانت';

  @override
  String get knowledgeBase => 'قاعدة المعرفة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get projectActionsHeader => 'إجراءات المشروع';
}
