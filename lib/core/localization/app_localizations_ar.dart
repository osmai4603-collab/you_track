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
  String get newTagTitle => 'وسم جديد';

  @override
  String get tagNameLabel => 'اسم الوسم';

  @override
  String get tagNameHint => 'أدخل اسم الوسم';

  @override
  String get removeOnResolutionLabel => 'الإزالة عند الحل';

  @override
  String get sharedLabel => 'مشترك';

  @override
  String get favoriteLabel => 'وضع علامة كمفضل لجميع المشاهدين';

  @override
  String get subscriptionsTitle => 'الاشتراكات';

  @override
  String get tagScopeOwner => 'المالك';

  @override
  String get tagScopeAdmin => 'مدير';

  @override
  String get tagScopeDeveloper => 'مطور';

  @override
  String get tagScopeViewer => 'مشاهد';

  @override
  String get tagScopeAllMembers => 'جميع الأعضاء';

  @override
  String get tagScopeSpecificUsers => 'مستخدمون محددون';

  @override
  String get tagPermissionView => 'يمكنه العرض';

  @override
  String get tagPermissionUse => 'يمكنه الاستخدام';

  @override
  String get tagPermissionEdit => 'يمكنه التعديل';

  @override
  String get tagEventUpdates => 'التحديثات';

  @override
  String get tagEventComments => 'التعليقات';

  @override
  String get tagEventTagAdded => 'تمت إضافة الوسم';

  @override
  String get tagEventSpentTime => 'الوقت المستغرق';

  @override
  String get tagEventIssueResolved => 'تم حل المشكلة';

  @override
  String get tagEventVotes => 'التصويتات';

  @override
  String get tagEventTagRemoved => 'تمت إزالة الوسم';

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

  @override
  String get customFieldsAddFieldToProject => 'إضافة حقل للمشروع ...';

  @override
  String get customFieldsEditField => 'تعديل حقل مخصص';

  @override
  String get customFieldsDeleteFields => 'حذف حقول مخصصة';

  @override
  String get customFieldsEmptyValue => 'القيمة عند الفراغ (اختياري)';

  @override
  String get customFieldsCanBeEmpty => 'يمكن أن يكون فارغاً';

  @override
  String get customFieldsValueMode => 'وضع القيمة';

  @override
  String get customFieldsValueModeSingle => 'مفرد';

  @override
  String get customFieldsValueModeMulti => 'متعدد';

  @override
  String get customFieldsAliases => 'الأسماء البديلة (اختياري، مفصولة بفاصلة)';

  @override
  String get customFieldsFieldMode => 'وضع الحقل';

  @override
  String get customFieldsVisibleTo => 'مرئي لـ';

  @override
  String get customFieldsUpdatableBy => 'قابل للتعديل بواسطة';

  @override
  String get customFieldsShowOnlyWhen => 'يظهر فقط عندما';

  @override
  String get customFieldsFilterValuesBasedOn => 'فلترة القيم بناء على';

  @override
  String get customFieldsAdvancedSettings => 'إعدادات متقدمة';

  @override
  String get customFieldsNoCustomFieldsYet => 'لا توجد حقول مخصصة بعد';

  @override
  String get customFieldsFieldDetails => 'تفاصيل الحقل';

  @override
  String get customFieldsMakePublicSuccess => 'الحقل مرئي للجميع الآن';

  @override
  String get customFieldsAccessControlUpdated => 'تم تحديث التحكم بالوصول';

  @override
  String customFieldsSelected(Object count) {
    return '$count محدد';
  }

  @override
  String customFieldsDeleteConfirmation(Object count) {
    return 'هل أنت متأكد من حذف $count حقل مخصص؟';
  }

  @override
  String get permissionDeniedTooltip => 'ليس لديك الصلاحية لتنفيذ هذا الإجراء';

  @override
  String get userProfileGeneral => 'عام';

  @override
  String get userProfileWorkspace => 'مساحة العمل';

  @override
  String get userProfileTagsAndSearches => 'الوسوم والبحوث المحفوظة';

  @override
  String get userProfileNotifications => 'الإشعارات';

  @override
  String get userProfileAccountSecurity => 'أمان الحساب';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get avatar => 'الصورة الرمزية';

  @override
  String get vcsUsernames => 'أسماء مستخدمي VCS';

  @override
  String get registrationDate => 'تاريخ التسجيل';

  @override
  String get personalData => 'البيانات الشخصية';

  @override
  String get downloadCsv => 'تنزيل بصيغة CSV';

  @override
  String get localTimezone => 'المنطقة الزمنية المحلية';

  @override
  String get guessTimezone => 'تخمين المنطقة الزمنية';

  @override
  String get sendTestMessage => 'إرسال رسالة اختبار';

  @override
  String get theme => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSyncOs => 'مزامنة مع النظام';

  @override
  String get linksPanelPosition => 'موضع لوحة الروابط';

  @override
  String get belowSummary => 'أسفل الملخص';

  @override
  String get belowDescription => 'أسفل الوصف';

  @override
  String get showRecentIssues => 'إظهار المشاكل والمقالات الأخيرة';

  @override
  String get newTagOrSearch => 'وسم أو بحث محفوظ جديد';

  @override
  String get delete => 'حذف';

  @override
  String get searchTagsAndSearches => 'البحث في الوسوم والبحوث';

  @override
  String get all => 'الكل';

  @override
  String get createdByMe => 'تم إنشاؤها بواسطتي';

  @override
  String get removeOnResolution => 'الإزالة عند الحل';

  @override
  String get markAsFavorite => 'وضع علامة كمفضل لجميع المشاهدين';

  @override
  String get notificationEvents => 'أحداث الإشعارات:';

  @override
  String get sendNotificationsTo => 'إرسال الإشعارات إلى:';

  @override
  String get starAutomaticallyWhen => 'وضع نجمة تلقائياً عندما:';

  @override
  String get twoFactorAuth => 'المصادقة الثنائية';

  @override
  String get credentials => 'بيانات الاعتماد';

  @override
  String get tokens => 'الرموز';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get revokeRefreshToken => 'إبطال رمز التحديث';

  @override
  String get deleteCredentials => 'حذف بيانات الاعتماد';

  @override
  String get pairWithApp => 'إقران مع التطبيق ...';

  @override
  String get pairWithHardwareToken => 'إقران مع رمز مادي ...';

  @override
  String get addCredentials => 'إضافة بيانات اعتماد ...';

  @override
  String get newToken => 'رمز جديد ...';

  @override
  String get newPasswordButton => 'كلمة مرور جديدة ...';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordChangedSuccess => 'تم تغيير كلمة المرور بنجاح';

  @override
  String passwordChangeFailed(Object error) {
    return 'فشل تغيير كلمة المرور: $error';
  }

  @override
  String get sessionsRevokedSuccess => 'تم إبطال الجلسات النشطة الأخرى';

  @override
  String sessionsRevokeFailed(Object error) {
    return 'فشل إبطال الجلسات: $error';
  }

  @override
  String get changesSavedSuccess => 'تم حفظ التغييرات بنجاح';

  @override
  String get noTagSelected => 'لم يتم تحديد أي عنصر للحذف';

  @override
  String get enterTagName => 'أدخل اسم الوسم...';

  @override
  String get enterSearchQuery => 'أدخل استعلام البحث...';

  @override
  String get searchSavedSearchType => 'بحث محفوظ';

  @override
  String get vcsUsernamesHint =>
      'إضافة معرّفات شخصية من أنظمة التحكم بالإصدارات المدمجة (VCS) تسمح لـ YouTrack بإضافة روابط للمشاكل المشار إليها في ارتكازات الكود الخاصة بك.';

  @override
  String profileLoadError(Object error) {
    return 'تعذر تحميل الملف الشخصي: $error';
  }

  @override
  String get changesByMe => 'التغييرات التي أجريتها أنا';

  @override
  String get mentionsMyUsername => '@إشارات تذكر اسم المستخدم الخاص بي';

  @override
  String get changesInDuplicateCluster => 'التغييرات في مجموعة المهام المكررة';

  @override
  String get issuesFromEmails =>
      'المشاكل والتعليقات المنشأة من بريدي الإلكتروني';

  @override
  String get vcsBuildUpdates =>
      'التحديثات المطبقة بواسطة تكاملات VCS وبناء الخادم';

  @override
  String get failedVcsCommands =>
      'الأوامر الفاشلة في الارتكازات التي تعالجها تكاملات VCS وبناء الخادم';

  @override
  String get starOnComment => 'أعلق على مشكلة أو مقالة';

  @override
  String get starOnCreate => 'أنشئ مشكلة أو مقالة';

  @override
  String get starOnUpdate => 'أحدّث مشكلة أو مقالة';

  @override
  String get starOnAssigned => 'أكون مسؤولاً عن مشكلة';

  @override
  String get starOnVote => 'أصوّت لمشكلة';

  @override
  String get emailChannel => 'البريد الإلكتروني';

  @override
  String get telegramChannel => 'روبوت YouTrack لتطبيق Telegram';

  @override
  String get connectTelegramAccount => 'ربط حسابي';

  @override
  String get testMessageSent => 'تم إرسال رسالة الاختبار إلى البريد الإلكتروني';

  @override
  String get downloadCsvStarted => 'جارٍ تنزيل البيانات الشخصية بصيغة CSV...';

  @override
  String timezoneGuessed(Object zone) {
    return 'تم تخمين المنطقة الزمنية: $zone (استناداً إلى عنوان IP)';
  }
}
