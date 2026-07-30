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
  String get saveButton => 'حفظ';

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
  String get noProjectsFound => 'لم يتم العثور على مشاريع';

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

  @override
  String get loginTitle => 'تسجيل الدخول إلى YouTrack';

  @override
  String get usernameOrEmailHint => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get rememberMeLabel => 'تذكرني';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get privacyPolicyLabel => 'بتسجيل الدخول، فإنك توافق على';

  @override
  String get privacyPolicyButton => 'سياسة الخصوصية';

  @override
  String get priorityShowStopper => 'عارض';

  @override
  String get priorityCritical => 'حرج';

  @override
  String get priorityMajor => 'رئيسي';

  @override
  String get priorityNormal => 'عادي';

  @override
  String get priorityMinor => 'ثانوي';

  @override
  String get typeBug => 'خلل';

  @override
  String get typeCosmetic => 'تجميلي';

  @override
  String get typeException => 'استثناء';

  @override
  String get typeFeature => 'ميزة';

  @override
  String get typeTask => 'مهمة';

  @override
  String get typeUsabilityProblem => 'مشكلة استخدام';

  @override
  String get typePerformanceProblem => 'مشكلة أداء';

  @override
  String get typeEpic => 'ملحمة';

  @override
  String get stateToDo => 'للتنفيذ';

  @override
  String get stateInProgress => 'قيد التنفيذ';

  @override
  String get stateDone => 'منتهي';

  @override
  String get subsystemNoValue => 'لا قيمة';

  @override
  String get subsystemIssueTracking => 'تتبع المشاكل';

  @override
  String get subsystemProjectManagement => 'إدارة المشاريع';

  @override
  String get subsystemMigration => 'ترحيل';

  @override
  String get roleContributor => 'مساهم';

  @override
  String get roleProjectAdmin => 'مدير مشروع';

  @override
  String get roleSystemAdmin => 'مدير نظام';

  @override
  String get serverTypeGithub => 'جيت‌هاب';

  @override
  String get serverTypeGitlab => 'جيت‌لاب';

  @override
  String get serverTypeBitbucket => 'بت‌باكيت';

  @override
  String get serverTypeBitbucketServer => 'خادم بت‌باكيت';

  @override
  String get serverTypeGogs => 'جوغز';

  @override
  String get serverTypeGitea => 'جيتيا';

  @override
  String get serverTypeSpace => 'سبيس';

  @override
  String get serverTypeGenerice => 'عام';

  @override
  String get serverTypeAzureRepos => 'أزور ريبوز';

  @override
  String get customFieldEnumTypeBuild => 'البناء';

  @override
  String get customFieldEnumTypeEnum => 'التعداد';

  @override
  String get customFieldEnumTypeGroup => 'المجموعة';

  @override
  String get customFieldEnumTypeOwnedField => 'الملف المملوك';

  @override
  String get customFieldEnumTypeState => 'الحالة';

  @override
  String get customFieldEnumTypeUser => 'المستخدم';

  @override
  String get customFieldEnumTypeVersion => 'الإصدار';

  @override
  String get customFieldEnumTypeDate => 'التاريخ';

  @override
  String get customFieldEnumTypeDateTime => 'التاريخ والوقت';

  @override
  String get customFieldEnumTypeFloat => 'عشري';

  @override
  String get customFieldEnumTypeInteger => 'عدد صحيح';

  @override
  String get customFieldEnumTypeString => 'نص';

  @override
  String get customFieldEnumTypeText => 'نص طويل';

  @override
  String get customFieldEnumTypePeriod => 'الفترة';

  @override
  String get searchMembersHint => 'البحث عن نص أو إضافة فلتر';

  @override
  String get teamRolesLabel => 'أدوار الفريق';

  @override
  String get ownerLabel => 'المالك';

  @override
  String get projectOwnerBadge => 'مالك المشروع';

  @override
  String get removeMemberAction => 'إزالة العضو';

  @override
  String get removeMemberConfirmTitle => 'إزالة العضو؟';

  @override
  String get removeMemberConfirmBody =>
      'هل أنت متأكد من إزالة هذا العضو من المشروع؟';

  @override
  String get emptyMembersTitle => 'لا يوجد أعضاء في الفريق بعد';

  @override
  String get accessDeniedTitle => 'تم رفض الوصول';

  @override
  String get accessDeniedBody => 'ليس لديك صلاحية لعرض هذه الصفحة';

  @override
  String get addWidgetButton => 'إضافة أداة';

  @override
  String get createButton => 'إنشاء';

  @override
  String get newIssueOption => 'مشكلة جديدة';

  @override
  String get newArticleOption => 'مقال جديد';

  @override
  String get widgetDocumentListWidget => 'قائمة المستندات';

  @override
  String get widgetIssueList => 'قائمة المشاكل';

  @override
  String get widgetIssueDistributionReport => 'تقرير توزيع المشاكل';

  @override
  String get widgetCalendarWidget => 'التقويم';

  @override
  String get widgetIssueActivityFeed => 'سجل نشاط المشاكل';

  @override
  String get widgetProjectTeam => 'فريق المشروع';

  @override
  String get widgetAccessEraser => 'محذوف الوصول';

  @override
  String get widgetQuickNotes => 'ملاحظات سريعة';

  @override
  String get widgetReport => 'تقرير';

  @override
  String get widgetPersonalTimeTracking => 'تتبع الوقت الشخصي';

  @override
  String get widgetTimeTrackingReport => 'تقرير تتبع الوقت';

  @override
  String get widgetWorkItemExporter => 'تصدير عناصر العمل';

  @override
  String get relatesToOption => 'يرتبط بـ';

  @override
  String get isRequiredForOption => 'مطلوب لـ';

  @override
  String get dependsOnOption => 'يعتمد على';

  @override
  String get isDuplicatedByOption => 'مكرر بواسطة';

  @override
  String get duplicatesOption => 'يكرر';

  @override
  String get parentForOption => 'أب لـ';

  @override
  String get subtaskOfOption => 'مهمة فرعية لـ';

  @override
  String get newTagTitle => 'New Tag';

  @override
  String get tagNameLabel => 'Tag Name';

  @override
  String get tagNameHint => 'Enter tag name';

  @override
  String get removeOnResolutionLabel => 'Remove on resolution';

  @override
  String get sharedLabel => 'Shared';

  @override
  String get favoriteLabel => 'Mark as favorite for all viewers';

  @override
  String get subscriptionsTitle => 'Subscriptions';

  @override
  String get tagScopeOwner => 'Owner';

  @override
  String get tagScopeAdmin => 'Admin';

  @override
  String get tagScopeDeveloper => 'Developer';

  @override
  String get tagScopeViewer => 'Viewer';

  @override
  String get tagScopeAllMembers => 'All Members';

  @override
  String get tagScopeSpecificUsers => 'Specific Users';

  @override
  String get tagPermissionView => 'Can view';

  @override
  String get tagPermissionUse => 'Can use';

  @override
  String get tagPermissionEdit => 'Can edit';

  @override
  String get tagEventUpdates => 'Updates';

  @override
  String get tagEventComments => 'Comments';

  @override
  String get tagEventTagAdded => 'Tag added';

  @override
  String get tagEventSpentTime => 'Spent time';

  @override
  String get tagEventIssueResolved => 'Issue resolved';

  @override
  String get tagEventVotes => 'Votes';

  @override
  String get tagEventTagRemoved => 'Tag removed';

  @override
  String get templateDefault => 'افتراضي';

  @override
  String get templateScrum => 'سكرُم';

  @override
  String get templateKanban => 'كانبان';

  @override
  String get templateTaskManagement => 'إدارة المهام';

  @override
  String get templateHelpdesk => 'الدعم الفني';

  @override
  String get templateProjectManagement => 'إدارة المشاريع';

  @override
  String get templateDemo => 'تجريبي';

  @override
  String get templateMarketing => 'تسويق';

  @override
  String get permissionProjectReadProjectBasic => 'بيانات المشروع الأساسية';

  @override
  String get permissionProjectCreateProject => 'مشروع جديد';

  @override
  String get permissionProjectReadProjectFull => 'تفاصيل المشروع بالكامل';

  @override
  String get permissionProjectUpdateProject => 'إعدادات المشروع';

  @override
  String get permissionProjectDeleteProject => 'المشروع';

  @override
  String get permissionOrganizationReadOrganization => 'بيانات المؤسسة';

  @override
  String get permissionOrganizationUpdateOrganization => 'بيانات المؤسسة';

  @override
  String get permissionOrganizationCreateOrganization => 'مؤسسة جديدة';

  @override
  String get permissionOrganizationDeleteOrganization => 'المؤسسة';

  @override
  String get permissionUserProfileUpdateSelf => 'الملف الشخصي';

  @override
  String get permissionUserReadUserBasic => 'بيانات المستخدمين الأساسية';

  @override
  String get permissionUserReadUserDetails => 'تفاصيل الحسابات الشاملة';

  @override
  String get permissionUserUpdateUser => 'حسابات المستخدمين';

  @override
  String get permissionUserCreateUser => 'حساب مستخدم جديد';

  @override
  String get permissionUserDeleteUser => 'حساب مستخدم';

  @override
  String get permissionSystemLowLevelAdminRead => 'إعدادات النظام المتقدمة';

  @override
  String get permissionSystemLowLevelAdminWrite => 'إعدادات النظام المتقدمة';

  @override
  String get permissionIssueReadIssue => 'بيانات المهام العامة';

  @override
  String get permissionIssueReadIssuePrivateFields => 'الحقول الخاصة بالمهام';

  @override
  String get permissionIssueUpdateIssue => 'المهام';

  @override
  String get permissionIssueCreateIssue => 'مهام جديدة';

  @override
  String get permissionIssueDeleteIssue => 'المهام';

  @override
  String get permissionIssueLinkIssues => 'المهام ببعضها';

  @override
  String get permissionIssueUpdateIssuePrivateFields => 'الحقول الخاصة بالمهام';

  @override
  String get permissionIssueApplyCommandsSilently =>
      'أوامر على المهام دون تنبيهات';

  @override
  String get permissionIssueViewWatchers => 'متابعي المهمة';

  @override
  String get permissionIssueUpdateWatchers => 'متابعي المهمة';

  @override
  String get permissionIssueViewVoters => 'المصوتين للمهمة';

  @override
  String get permissionAttachmentAddAttachment => 'مرفقات للمهمة';

  @override
  String get permissionAttachmentUpdateAttachment => 'المرفقات والرؤية';

  @override
  String get permissionAttachmentDeleteAttachment => 'المرفقات';

  @override
  String get permissionCommentCreateIssueComment => 'تعليق على المهمة';

  @override
  String get permissionCommentReadIssueComment => 'تعليقات المهمة';

  @override
  String get permissionCommentUpdateIssueComment => 'التعليق الشخصي';

  @override
  String get permissionCommentDeleteIssueComment => 'التعليق الشخصي';

  @override
  String get permissionCommentUpdateNotOwnIssueComment => 'تعليقات الآخرين';

  @override
  String get permissionCommentDeleteNotOwnCommentAndPermanentCommentDelete =>
      'تعليقات الآخرين نهائياً';

  @override
  String get permissionCommentReadArticleComment => 'تعليقات المقالات';

  @override
  String get permissionCommentCreateArticleComment => 'تعليق على المقالات';

  @override
  String get permissionCommentUpdateArticleComment => 'تعليق على مقال';

  @override
  String get permissionCommentDeleteArticleComment => 'تعليق على مقال';

  @override
  String get permissionVisibilityOverrideVisibilityRestrictions =>
      'قيود رؤية العناصر';

  @override
  String get permissionIssueWorkItemReadWorkItem => 'سجلات الوقت والعمل';

  @override
  String get permissionIssueWorkItemUpdateWorkItem => 'سجلات العمل الخاصة';

  @override
  String get permissionIssueWorkItemUpdateNotOwnWorkItem => 'سجلات عمل الآخرين';

  @override
  String get permissionIssueWorkItemCreateWorkItem => 'سجل عمل جديد';

  @override
  String get permissionIssueWorkItemCreateNotOwnWorkItem =>
      'سجل عمل باسم شخص آخر';

  @override
  String get permissionArticleReadArticle => 'مقالات قاعدة المعرفة';

  @override
  String get permissionArticleCreateArticle => 'مقال جديد';

  @override
  String get permissionArticleUpdateArticle => 'مقال';

  @override
  String get permissionArticleDeleteArticle => 'مقال';

  @override
  String get permissionAppReadAppContent => 'محتوى التطبيقات المضافة';

  @override
  String get permissionAppUpdateAppContent => 'محتوى التطبيقات المضافة';
}
