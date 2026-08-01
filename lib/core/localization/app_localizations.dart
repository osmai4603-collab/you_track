import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Issues Tracking'**
  String get appName;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Issues Tracking'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @issues.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get issues;

  /// No description provided for @board.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get board;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @createIssue.
  ///
  /// In en, this message translates to:
  /// **'Create Issue'**
  String get createIssue;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @filterProjectsHint.
  ///
  /// In en, this message translates to:
  /// **'Filter projects by name or ID'**
  String get filterProjectsHint;

  /// No description provided for @newProjectButton.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get newProjectButton;

  /// No description provided for @editProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editProjectButton;

  /// No description provided for @cloneProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Clone'**
  String get cloneProjectButton;

  /// No description provided for @archiveProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveProjectButton;

  /// No description provided for @convertToTemplateButton.
  ///
  /// In en, this message translates to:
  /// **'Convert to template'**
  String get convertToTemplateButton;

  /// No description provided for @deleteProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteProjectButton;

  /// No description provided for @selectTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get selectTemplateTitle;

  /// No description provided for @defaultTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Default Project Template'**
  String get defaultTemplateTitle;

  /// No description provided for @useThisTemplateButton.
  ///
  /// In en, this message translates to:
  /// **'Use this template'**
  String get useThisTemplateButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @projectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get projectNameLabel;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for your project'**
  String get projectNameHint;

  /// No description provided for @projectIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Project ID'**
  String get projectIdLabel;

  /// No description provided for @projectIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter project ID'**
  String get projectIdHint;

  /// No description provided for @createProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Create project'**
  String get createProjectButton;

  /// No description provided for @moreSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'More settings'**
  String get moreSettingsButton;

  /// No description provided for @addPeopleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add people to your new project'**
  String get addPeopleTitle;

  /// No description provided for @selectUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Select users and groups or enter an email address'**
  String get selectUsersHint;

  /// No description provided for @userLicensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard user licenses: 8'**
  String get userLicensesLabel;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @skipSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Skip setup and go to project'**
  String get skipSetupButton;

  /// No description provided for @ownedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Owned by {owner}'**
  String ownedByLabel(Object owner);

  /// No description provided for @createdOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOnLabel(Object date);

  /// No description provided for @noIssuesFoundBody.
  ///
  /// In en, this message translates to:
  /// **'No issues found'**
  String get noIssuesFoundBody;

  /// No description provided for @noProjectsFound.
  ///
  /// In en, this message translates to:
  /// **'No projects found'**
  String get noProjectsFound;

  /// No description provided for @editSearchQueryButton.
  ///
  /// In en, this message translates to:
  /// **'Edit search query'**
  String get editSearchQueryButton;

  /// No description provided for @agileBoardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Agile Boards'**
  String get agileBoardsTitle;

  /// No description provided for @scrumBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Scrum board'**
  String get scrumBoardTitle;

  /// No description provided for @kanbanBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Kanban board'**
  String get kanbanBoardTitle;

  /// No description provided for @versionBasedBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Version-based board'**
  String get versionBasedBoardTitle;

  /// No description provided for @customBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom board'**
  String get customBoardTitle;

  /// No description provided for @personalBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal board'**
  String get personalBoardTitle;

  /// No description provided for @projectTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Team'**
  String get projectTeamTitle;

  /// No description provided for @otherPeopleAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Other People with Access'**
  String get otherPeopleAccessTitle;

  /// No description provided for @addPeopleButton.
  ///
  /// In en, this message translates to:
  /// **'Add people...'**
  String get addPeopleButton;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @ganttCharts.
  ///
  /// In en, this message translates to:
  /// **'Gantt Charts'**
  String get ganttCharts;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get knowledgeBase;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @projectActionsHeader.
  ///
  /// In en, this message translates to:
  /// **'Project Actions'**
  String get projectActionsHeader;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to YouTrack'**
  String get loginTitle;

  /// No description provided for @usernameOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @rememberMeLabel.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMeLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'By logging in, you agree to the'**
  String get privacyPolicyLabel;

  /// No description provided for @privacyPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyButton;

  /// No description provided for @priorityShowStopper.
  ///
  /// In en, this message translates to:
  /// **'Show Stopper'**
  String get priorityShowStopper;

  /// No description provided for @priorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get priorityCritical;

  /// No description provided for @priorityMajor.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get priorityMajor;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor'**
  String get priorityMinor;

  /// No description provided for @typeBug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get typeBug;

  /// No description provided for @typeCosmetic.
  ///
  /// In en, this message translates to:
  /// **'Cosmetic'**
  String get typeCosmetic;

  /// No description provided for @typeException.
  ///
  /// In en, this message translates to:
  /// **'Exception'**
  String get typeException;

  /// No description provided for @typeFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get typeFeature;

  /// No description provided for @typeTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get typeTask;

  /// No description provided for @typeUsabilityProblem.
  ///
  /// In en, this message translates to:
  /// **'Usability Problem'**
  String get typeUsabilityProblem;

  /// No description provided for @typePerformanceProblem.
  ///
  /// In en, this message translates to:
  /// **'Performance Problem'**
  String get typePerformanceProblem;

  /// No description provided for @typeEpic.
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get typeEpic;

  /// No description provided for @stateToDo.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get stateToDo;

  /// No description provided for @stateInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get stateInProgress;

  /// No description provided for @stateDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stateDone;

  /// No description provided for @subsystemNoValue.
  ///
  /// In en, this message translates to:
  /// **'No Value'**
  String get subsystemNoValue;

  /// No description provided for @subsystemIssueTracking.
  ///
  /// In en, this message translates to:
  /// **'Issue Tracking'**
  String get subsystemIssueTracking;

  /// No description provided for @subsystemProjectManagement.
  ///
  /// In en, this message translates to:
  /// **'Project Management'**
  String get subsystemProjectManagement;

  /// No description provided for @subsystemMigration.
  ///
  /// In en, this message translates to:
  /// **'Migration'**
  String get subsystemMigration;

  /// No description provided for @roleContributor.
  ///
  /// In en, this message translates to:
  /// **'Contributor'**
  String get roleContributor;

  /// No description provided for @roleProjectAdmin.
  ///
  /// In en, this message translates to:
  /// **'Project Admin'**
  String get roleProjectAdmin;

  /// No description provided for @roleSystemAdmin.
  ///
  /// In en, this message translates to:
  /// **'System Admin'**
  String get roleSystemAdmin;

  /// No description provided for @serverTypeGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get serverTypeGithub;

  /// No description provided for @serverTypeGitlab.
  ///
  /// In en, this message translates to:
  /// **'GitLab'**
  String get serverTypeGitlab;

  /// No description provided for @serverTypeBitbucket.
  ///
  /// In en, this message translates to:
  /// **'Bitbucket'**
  String get serverTypeBitbucket;

  /// No description provided for @serverTypeBitbucketServer.
  ///
  /// In en, this message translates to:
  /// **'Bitbucket Server'**
  String get serverTypeBitbucketServer;

  /// No description provided for @serverTypeGogs.
  ///
  /// In en, this message translates to:
  /// **'Gogs'**
  String get serverTypeGogs;

  /// No description provided for @serverTypeGitea.
  ///
  /// In en, this message translates to:
  /// **'Gitea'**
  String get serverTypeGitea;

  /// No description provided for @serverTypeSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get serverTypeSpace;

  /// No description provided for @serverTypeGenerice.
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get serverTypeGenerice;

  /// No description provided for @serverTypeAzureRepos.
  ///
  /// In en, this message translates to:
  /// **'Azure Repos'**
  String get serverTypeAzureRepos;

  /// Display name for Build field type
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get customFieldEnumTypeBuild;

  /// Display name for Enum field type
  ///
  /// In en, this message translates to:
  /// **'Enum'**
  String get customFieldEnumTypeEnum;

  /// Display name for Group field type
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get customFieldEnumTypeGroup;

  /// Display name for Owned Field field type
  ///
  /// In en, this message translates to:
  /// **'Owned Field'**
  String get customFieldEnumTypeOwnedField;

  /// Display name for State field type
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get customFieldEnumTypeState;

  /// Display name for User field type
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get customFieldEnumTypeUser;

  /// Display name for Version field type
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get customFieldEnumTypeVersion;

  /// Display name for Date field type
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get customFieldEnumTypeDate;

  /// Display name for Date Time field type
  ///
  /// In en, this message translates to:
  /// **'Date Time'**
  String get customFieldEnumTypeDateTime;

  /// Display name for Float field type
  ///
  /// In en, this message translates to:
  /// **'Float'**
  String get customFieldEnumTypeFloat;

  /// Display name for Integer field type
  ///
  /// In en, this message translates to:
  /// **'Integer'**
  String get customFieldEnumTypeInteger;

  /// Display name for String field type
  ///
  /// In en, this message translates to:
  /// **'String'**
  String get customFieldEnumTypeString;

  /// Display name for Text field type
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get customFieldEnumTypeText;

  /// Display name for Period field type
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get customFieldEnumTypePeriod;

  /// No description provided for @searchMembersHint.
  ///
  /// In en, this message translates to:
  /// **'Search for text or add a filter'**
  String get searchMembersHint;

  /// No description provided for @teamRolesLabel.
  ///
  /// In en, this message translates to:
  /// **'Team roles'**
  String get teamRolesLabel;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @projectOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'project owner'**
  String get projectOwnerBadge;

  /// No description provided for @removeMemberAction.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMemberAction;

  /// No description provided for @removeMemberConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get removeMemberConfirmTitle;

  /// No description provided for @removeMemberConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this member from the project?'**
  String get removeMemberConfirmBody;

  /// No description provided for @emptyMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'No team members yet'**
  String get emptyMembersTitle;

  /// No description provided for @accessDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDeniedTitle;

  /// No description provided for @accessDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to view this page'**
  String get accessDeniedBody;

  /// No description provided for @addWidgetButton.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get addWidgetButton;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @newIssueOption.
  ///
  /// In en, this message translates to:
  /// **'New issue'**
  String get newIssueOption;

  /// No description provided for @newArticleOption.
  ///
  /// In en, this message translates to:
  /// **'New article'**
  String get newArticleOption;

  /// No description provided for @widgetDocumentListWidget.
  ///
  /// In en, this message translates to:
  /// **'Document List Widget'**
  String get widgetDocumentListWidget;

  /// No description provided for @widgetIssueList.
  ///
  /// In en, this message translates to:
  /// **'Issue List'**
  String get widgetIssueList;

  /// No description provided for @widgetIssueDistributionReport.
  ///
  /// In en, this message translates to:
  /// **'Issue Distribution Report'**
  String get widgetIssueDistributionReport;

  /// No description provided for @widgetCalendarWidget.
  ///
  /// In en, this message translates to:
  /// **'Calendar Widget'**
  String get widgetCalendarWidget;

  /// No description provided for @widgetIssueActivityFeed.
  ///
  /// In en, this message translates to:
  /// **'Issue Activity Feed'**
  String get widgetIssueActivityFeed;

  /// No description provided for @widgetProjectTeam.
  ///
  /// In en, this message translates to:
  /// **'Project Team'**
  String get widgetProjectTeam;

  /// No description provided for @widgetAccessEraser.
  ///
  /// In en, this message translates to:
  /// **'Access Eraser'**
  String get widgetAccessEraser;

  /// No description provided for @widgetQuickNotes.
  ///
  /// In en, this message translates to:
  /// **'Quick Notes'**
  String get widgetQuickNotes;

  /// No description provided for @widgetReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get widgetReport;

  /// No description provided for @widgetPersonalTimeTracking.
  ///
  /// In en, this message translates to:
  /// **'Personal Time Tracking'**
  String get widgetPersonalTimeTracking;

  /// No description provided for @widgetTimeTrackingReport.
  ///
  /// In en, this message translates to:
  /// **'Time Tracking Report'**
  String get widgetTimeTrackingReport;

  /// No description provided for @widgetWorkItemExporter.
  ///
  /// In en, this message translates to:
  /// **'Work Item Exporter'**
  String get widgetWorkItemExporter;

  /// No description provided for @relatesToOption.
  ///
  /// In en, this message translates to:
  /// **'Relates to'**
  String get relatesToOption;

  /// No description provided for @isRequiredForOption.
  ///
  /// In en, this message translates to:
  /// **'Is required for'**
  String get isRequiredForOption;

  /// No description provided for @dependsOnOption.
  ///
  /// In en, this message translates to:
  /// **'Depends on'**
  String get dependsOnOption;

  /// No description provided for @isDuplicatedByOption.
  ///
  /// In en, this message translates to:
  /// **'Is duplicated by'**
  String get isDuplicatedByOption;

  /// No description provided for @duplicatesOption.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get duplicatesOption;

  /// No description provided for @parentForOption.
  ///
  /// In en, this message translates to:
  /// **'Parent for'**
  String get parentForOption;

  /// No description provided for @subtaskOfOption.
  ///
  /// In en, this message translates to:
  /// **'Subtask of'**
  String get subtaskOfOption;

  /// No description provided for @newTagTitle.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get newTagTitle;

  /// No description provided for @tagNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tagNameLabel;

  /// No description provided for @tagNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter tag name'**
  String get tagNameHint;

  /// No description provided for @removeOnResolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove on resolution'**
  String get removeOnResolutionLabel;

  /// No description provided for @sharedLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get sharedLabel;

  /// No description provided for @favoriteLabel.
  ///
  /// In en, this message translates to:
  /// **'Mark as favorite for all viewers'**
  String get favoriteLabel;

  /// No description provided for @subscriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptionsTitle;

  /// No description provided for @tagScopeOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get tagScopeOwner;

  /// No description provided for @tagScopeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get tagScopeAdmin;

  /// No description provided for @tagScopeDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get tagScopeDeveloper;

  /// No description provided for @tagScopeViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get tagScopeViewer;

  /// No description provided for @tagScopeAllMembers.
  ///
  /// In en, this message translates to:
  /// **'All Members'**
  String get tagScopeAllMembers;

  /// No description provided for @tagScopeSpecificUsers.
  ///
  /// In en, this message translates to:
  /// **'Specific Users'**
  String get tagScopeSpecificUsers;

  /// No description provided for @tagPermissionView.
  ///
  /// In en, this message translates to:
  /// **'Can view'**
  String get tagPermissionView;

  /// No description provided for @tagPermissionUse.
  ///
  /// In en, this message translates to:
  /// **'Can use'**
  String get tagPermissionUse;

  /// No description provided for @tagPermissionEdit.
  ///
  /// In en, this message translates to:
  /// **'Can edit'**
  String get tagPermissionEdit;

  /// No description provided for @tagEventUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get tagEventUpdates;

  /// No description provided for @tagEventComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get tagEventComments;

  /// No description provided for @tagEventTagAdded.
  ///
  /// In en, this message translates to:
  /// **'Tag added'**
  String get tagEventTagAdded;

  /// No description provided for @tagEventSpentTime.
  ///
  /// In en, this message translates to:
  /// **'Spent time'**
  String get tagEventSpentTime;

  /// No description provided for @tagEventIssueResolved.
  ///
  /// In en, this message translates to:
  /// **'Issue resolved'**
  String get tagEventIssueResolved;

  /// No description provided for @tagEventVotes.
  ///
  /// In en, this message translates to:
  /// **'Votes'**
  String get tagEventVotes;

  /// No description provided for @tagEventTagRemoved.
  ///
  /// In en, this message translates to:
  /// **'Tag removed'**
  String get tagEventTagRemoved;

  /// Default project template
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get templateDefault;

  /// Scrum project template
  ///
  /// In en, this message translates to:
  /// **'Scrum'**
  String get templateScrum;

  /// Kanban project template
  ///
  /// In en, this message translates to:
  /// **'Kanban'**
  String get templateKanban;

  /// Task management project template
  ///
  /// In en, this message translates to:
  /// **'Task Management'**
  String get templateTaskManagement;

  /// Helpdesk project template
  ///
  /// In en, this message translates to:
  /// **'Helpdesk'**
  String get templateHelpdesk;

  /// Project management template
  ///
  /// In en, this message translates to:
  /// **'Project Management'**
  String get templateProjectManagement;

  /// Demo project template
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get templateDemo;

  /// Marketing project template
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get templateMarketing;

  /// Permission: Read Project Basic
  ///
  /// In en, this message translates to:
  /// **'Project Basic'**
  String get permissionProjectReadProjectBasic;

  /// Permission: Create Project
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get permissionProjectCreateProject;

  /// Permission: Read Project Full
  ///
  /// In en, this message translates to:
  /// **'Project Full'**
  String get permissionProjectReadProjectFull;

  /// Permission: Update Project
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get permissionProjectUpdateProject;

  /// Permission: Delete Project
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get permissionProjectDeleteProject;

  /// Permission: Read Organization
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get permissionOrganizationReadOrganization;

  /// Permission: Update Organization
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get permissionOrganizationUpdateOrganization;

  /// Permission: Create Organization
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get permissionOrganizationCreateOrganization;

  /// Permission: Delete Organization
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get permissionOrganizationDeleteOrganization;

  /// Permission: Update Self Profile
  ///
  /// In en, this message translates to:
  /// **'Self Profile'**
  String get permissionUserProfileUpdateSelf;

  /// Permission: Read User Basic
  ///
  /// In en, this message translates to:
  /// **'User Basic'**
  String get permissionUserReadUserBasic;

  /// Permission: Read User Details
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get permissionUserReadUserDetails;

  /// Permission: Update User
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get permissionUserUpdateUser;

  /// Permission: Create User
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get permissionUserCreateUser;

  /// Permission: Delete User
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get permissionUserDeleteUser;

  /// Permission: Read Low-Level Admin Settings
  ///
  /// In en, this message translates to:
  /// **'Low-Level Admin Settings'**
  String get permissionSystemLowLevelAdminRead;

  /// Permission: Write Low-Level Admin Settings
  ///
  /// In en, this message translates to:
  /// **'Low-Level Admin Settings'**
  String get permissionSystemLowLevelAdminWrite;

  /// Permission: Read Issue
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get permissionIssueReadIssue;

  /// Permission: Read Issue Private Fields
  ///
  /// In en, this message translates to:
  /// **'Issue Private Fields'**
  String get permissionIssueReadIssuePrivateFields;

  /// Permission: Update Issue
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get permissionIssueUpdateIssue;

  /// Permission: Create Issue
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get permissionIssueCreateIssue;

  /// Permission: Delete Issue
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get permissionIssueDeleteIssue;

  /// Permission: Link Issues
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get permissionIssueLinkIssues;

  /// Permission: Update Issue Private Fields
  ///
  /// In en, this message translates to:
  /// **'Issue Private Fields'**
  String get permissionIssueUpdateIssuePrivateFields;

  /// Permission: Apply Commands Silently
  ///
  /// In en, this message translates to:
  /// **'Commands Silently'**
  String get permissionIssueApplyCommandsSilently;

  /// Permission: View Watchers
  ///
  /// In en, this message translates to:
  /// **'Watchers'**
  String get permissionIssueViewWatchers;

  /// Permission: Update Watchers
  ///
  /// In en, this message translates to:
  /// **'Watchers'**
  String get permissionIssueUpdateWatchers;

  /// Permission: View Voters
  ///
  /// In en, this message translates to:
  /// **'Voters'**
  String get permissionIssueViewVoters;

  /// Permission: Add Attachment
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get permissionAttachmentAddAttachment;

  /// Permission: Update Attachment
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get permissionAttachmentUpdateAttachment;

  /// Permission: Delete Attachment
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get permissionAttachmentDeleteAttachment;

  /// Permission: Create Issue Comment
  ///
  /// In en, this message translates to:
  /// **'Issue Comment'**
  String get permissionCommentCreateIssueComment;

  /// Permission: Read Issue Comment
  ///
  /// In en, this message translates to:
  /// **'Issue Comment'**
  String get permissionCommentReadIssueComment;

  /// Permission: Update Issue Comment
  ///
  /// In en, this message translates to:
  /// **'Issue Comment'**
  String get permissionCommentUpdateIssueComment;

  /// Permission: Delete Issue Comment
  ///
  /// In en, this message translates to:
  /// **'Issue Comment'**
  String get permissionCommentDeleteIssueComment;

  /// Permission: Update Not Own Issue Comment
  ///
  /// In en, this message translates to:
  /// **'Not Own Issue Comment'**
  String get permissionCommentUpdateNotOwnIssueComment;

  /// Permission: Delete Not Own Comment & Permanent Delete
  ///
  /// In en, this message translates to:
  /// **'Not Own Comment & Permanent Delete'**
  String get permissionCommentDeleteNotOwnCommentAndPermanentCommentDelete;

  /// Permission: Read Article Comment
  ///
  /// In en, this message translates to:
  /// **'Article Comment'**
  String get permissionCommentReadArticleComment;

  /// Permission: Create Article Comment
  ///
  /// In en, this message translates to:
  /// **'Article Comment'**
  String get permissionCommentCreateArticleComment;

  /// Permission: Update Article Comment
  ///
  /// In en, this message translates to:
  /// **'Article Comment'**
  String get permissionCommentUpdateArticleComment;

  /// Permission: Delete Article Comment
  ///
  /// In en, this message translates to:
  /// **'Article Comment'**
  String get permissionCommentDeleteArticleComment;

  /// Permission: Override Visibility Restrictions
  ///
  /// In en, this message translates to:
  /// **'Visibility Restrictions'**
  String get permissionVisibilityOverrideVisibilityRestrictions;

  /// Permission: Read Work Item
  ///
  /// In en, this message translates to:
  /// **'Work Item'**
  String get permissionIssueWorkItemReadWorkItem;

  /// Permission: Update Work Item
  ///
  /// In en, this message translates to:
  /// **'Work Item'**
  String get permissionIssueWorkItemUpdateWorkItem;

  /// Permission: Update Not Own Work Item
  ///
  /// In en, this message translates to:
  /// **'Not Own Work Item'**
  String get permissionIssueWorkItemUpdateNotOwnWorkItem;

  /// Permission: Create Work Item
  ///
  /// In en, this message translates to:
  /// **'Work Item'**
  String get permissionIssueWorkItemCreateWorkItem;

  /// Permission: Create Not Own Work Item
  ///
  /// In en, this message translates to:
  /// **'Not Own Work Item'**
  String get permissionIssueWorkItemCreateNotOwnWorkItem;

  /// Permission: Read Article
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get permissionArticleReadArticle;

  /// Permission: Create Article
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get permissionArticleCreateArticle;

  /// Permission: Update Article
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get permissionArticleUpdateArticle;

  /// Permission: Delete Article
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get permissionArticleDeleteArticle;

  /// Permission: Read App Content
  ///
  /// In en, this message translates to:
  /// **'App Content'**
  String get permissionAppReadAppContent;

  /// Permission: Update App Content
  ///
  /// In en, this message translates to:
  /// **'App Content'**
  String get permissionAppUpdateAppContent;

  /// Button to add a new custom field to the project
  ///
  /// In en, this message translates to:
  /// **'Add field to project ...'**
  String get customFieldsAddFieldToProject;

  /// Title for editing a custom field
  ///
  /// In en, this message translates to:
  /// **'Edit Custom Field'**
  String get customFieldsEditField;

  /// Title for deleting custom fields
  ///
  /// In en, this message translates to:
  /// **'Delete Custom Fields'**
  String get customFieldsDeleteFields;

  /// Label for empty value field
  ///
  /// In en, this message translates to:
  /// **'Empty value (optional)'**
  String get customFieldsEmptyValue;

  /// Label for can be empty toggle
  ///
  /// In en, this message translates to:
  /// **'Can be empty'**
  String get customFieldsCanBeEmpty;

  /// Label for value mode field
  ///
  /// In en, this message translates to:
  /// **'Value mode'**
  String get customFieldsValueMode;

  /// Single value mode option
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get customFieldsValueModeSingle;

  /// Multi value mode option
  ///
  /// In en, this message translates to:
  /// **'Multi'**
  String get customFieldsValueModeMulti;

  /// Label for aliases field
  ///
  /// In en, this message translates to:
  /// **'Aliases (optional, comma-separated)'**
  String get customFieldsAliases;

  /// Label for field mode
  ///
  /// In en, this message translates to:
  /// **'Field mode'**
  String get customFieldsFieldMode;

  /// Label for visible to field
  ///
  /// In en, this message translates to:
  /// **'Visible to'**
  String get customFieldsVisibleTo;

  /// Label for updatable by field
  ///
  /// In en, this message translates to:
  /// **'Updatable by'**
  String get customFieldsUpdatableBy;

  /// Label for show only when field
  ///
  /// In en, this message translates to:
  /// **'Show only when'**
  String get customFieldsShowOnlyWhen;

  /// Label for filter values based on field
  ///
  /// In en, this message translates to:
  /// **'Filter values based on'**
  String get customFieldsFilterValuesBasedOn;

  /// Button for advanced settings
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get customFieldsAdvancedSettings;

  /// Empty state message when no custom fields exist
  ///
  /// In en, this message translates to:
  /// **'No custom fields yet'**
  String get customFieldsNoCustomFieldsYet;

  /// Title for field details panel
  ///
  /// In en, this message translates to:
  /// **'Field Details'**
  String get customFieldsFieldDetails;

  /// Snackbar message when field is made public
  ///
  /// In en, this message translates to:
  /// **'Field is now visible to everyone'**
  String get customFieldsMakePublicSuccess;

  /// Snackbar message when access control is updated
  ///
  /// In en, this message translates to:
  /// **'Access control updated'**
  String get customFieldsAccessControlUpdated;

  /// Shows count of selected fields
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String customFieldsSelected(Object count);

  /// Confirmation message for deleting custom fields
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} custom field(s)?'**
  String customFieldsDeleteConfirmation(Object count);

  /// Tooltip shown when an action is disabled due to missing permission
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action'**
  String get permissionDeniedTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
