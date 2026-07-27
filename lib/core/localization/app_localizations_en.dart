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

  @override
  String get projectsTitle => 'Projects';

  @override
  String get filterProjectsHint => 'Filter projects by name or ID';

  @override
  String get newProjectButton => 'New project';

  @override
  String get editProjectButton => 'Edit';

  @override
  String get cloneProjectButton => 'Clone';

  @override
  String get archiveProjectButton => 'Archive';

  @override
  String get convertToTemplateButton => 'Convert to template';

  @override
  String get deleteProjectButton => 'Delete';

  @override
  String get selectTemplateTitle => 'New Project';

  @override
  String get defaultTemplateTitle => 'Default Project Template';

  @override
  String get useThisTemplateButton => 'Use this template';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get projectNameLabel => 'Name';

  @override
  String get projectNameHint => 'Enter a name for your project';

  @override
  String get projectIdLabel => 'Project ID';

  @override
  String get projectIdHint => 'Enter project ID';

  @override
  String get createProjectButton => 'Create project';

  @override
  String get moreSettingsButton => 'More settings';

  @override
  String get addPeopleTitle => 'Add people to your new project';

  @override
  String get selectUsersHint =>
      'Select users and groups or enter an email address';

  @override
  String get userLicensesLabel => 'Standard user licenses: 8';

  @override
  String get backButton => 'Back';

  @override
  String get nextButton => 'Next';

  @override
  String get skipSetupButton => 'Skip setup and go to project';

  @override
  String ownedByLabel(Object owner) {
    return 'Owned by $owner';
  }

  @override
  String createdOnLabel(Object date) {
    return 'Created on $date';
  }

  @override
  String get noIssuesFoundBody => 'No issues found';

  @override
  String get noProjectsFound => 'No projects found';

  @override
  String get editSearchQueryButton => 'Edit search query';

  @override
  String get agileBoardsTitle => 'Agile Boards';

  @override
  String get scrumBoardTitle => 'Scrum board';

  @override
  String get kanbanBoardTitle => 'Kanban board';

  @override
  String get versionBasedBoardTitle => 'Version-based board';

  @override
  String get customBoardTitle => 'Custom board';

  @override
  String get personalBoardTitle => 'Personal board';

  @override
  String get projectTeamTitle => 'Project Team';

  @override
  String get otherPeopleAccessTitle => 'Other People with Access';

  @override
  String get addPeopleButton => 'Add people...';

  @override
  String get overview => 'Overview';

  @override
  String get ganttCharts => 'Gantt Charts';

  @override
  String get knowledgeBase => 'Knowledge Base';

  @override
  String get settings => 'Settings';

  @override
  String get projectActionsHeader => 'Project Actions';

  @override
  String get loginTitle => 'Log in to YouTrack';

  @override
  String get usernameOrEmailHint => 'Username or Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get rememberMeLabel => 'Remember me';

  @override
  String get resetPasswordButton => 'Reset password';

  @override
  String get loginButton => 'Log in';

  @override
  String get privacyPolicyLabel => 'By logging in, you agree to the';

  @override
  String get privacyPolicyButton => 'Privacy Policy';

  @override
  String get priorityShowStopper => 'Show Stopper';

  @override
  String get priorityCritical => 'Critical';

  @override
  String get priorityMajor => 'Major';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityMinor => 'Minor';

  @override
  String get typeBug => 'Bug';

  @override
  String get typeCosmetic => 'Cosmetic';

  @override
  String get typeException => 'Exception';

  @override
  String get typeFeature => 'Feature';

  @override
  String get typeTask => 'Task';

  @override
  String get typeUsabilityProblem => 'Usability Problem';

  @override
  String get typePerformanceProblem => 'Performance Problem';

  @override
  String get typeEpic => 'Epic';

  @override
  String get stateToDo => 'To Do';

  @override
  String get stateInProgress => 'In Progress';

  @override
  String get stateDone => 'Done';

  @override
  String get subsystemNoValue => 'No Value';

  @override
  String get subsystemIssueTracking => 'Issue Tracking';

  @override
  String get subsystemProjectManagement => 'Project Management';

  @override
  String get subsystemMigration => 'Migration';

  @override
  String get roleContributor => 'Contributor';

  @override
  String get roleProjectAdmin => 'Project Admin';

  @override
  String get roleSystemAdmin => 'System Admin';

  @override
  String get serverTypeGithub => 'GitHub';

  @override
  String get serverTypeGitlab => 'GitLab';

  @override
  String get serverTypeBitbucket => 'Bitbucket';

  @override
  String get serverTypeBitbucketServer => 'Bitbucket Server';

  @override
  String get serverTypeGogs => 'Gogs';

  @override
  String get serverTypeGitea => 'Gitea';

  @override
  String get serverTypeSpace => 'Space';

  @override
  String get serverTypeGenerice => 'Generic';

  @override
  String get serverTypeAzureRepos => 'Azure Repos';

  @override
  String get customFieldEnumTypeBuild => 'Build';

  @override
  String get customFieldEnumTypeEnum => 'Enum';

  @override
  String get customFieldEnumTypeGroup => 'Group';

  @override
  String get customFieldEnumTypeOwnedField => 'Owned Field';

  @override
  String get customFieldEnumTypeState => 'State';

  @override
  String get customFieldEnumTypeUser => 'User';

  @override
  String get customFieldEnumTypeVersion => 'Version';

  @override
  String get customFieldEnumTypeDate => 'Date';

  @override
  String get customFieldEnumTypeDateTime => 'Date Time';

  @override
  String get customFieldEnumTypeFloat => 'Float';

  @override
  String get customFieldEnumTypeInteger => 'Integer';

  @override
  String get customFieldEnumTypeString => 'String';

  @override
  String get customFieldEnumTypeText => 'Text';

  @override
  String get customFieldEnumTypePeriod => 'Period';

  @override
  String get searchMembersHint => 'Search for text or add a filter';

  @override
  String get teamRolesLabel => 'Team roles';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get projectOwnerBadge => 'project owner';

  @override
  String get removeMemberAction => 'Remove member';

  @override
  String get removeMemberConfirmTitle => 'Remove member?';

  @override
  String get removeMemberConfirmBody =>
      'Are you sure you want to remove this member from the project?';

  @override
  String get emptyMembersTitle => 'No team members yet';

  @override
  String get accessDeniedTitle => 'Access Denied';

  @override
  String get accessDeniedBody => 'You don\'t have permission to view this page';

  @override
  String get addWidgetButton => 'Add widget';

  @override
  String get createButton => 'Create';

  @override
  String get newIssueOption => 'New issue';

  @override
  String get newArticleOption => 'New article';

  @override
  String get widgetDocumentListWidget => 'Document List Widget';

  @override
  String get widgetIssueList => 'Issue List';

  @override
  String get widgetIssueDistributionReport => 'Issue Distribution Report';

  @override
  String get widgetCalendarWidget => 'Calendar Widget';

  @override
  String get widgetIssueActivityFeed => 'Issue Activity Feed';

  @override
  String get widgetProjectTeam => 'Project Team';

  @override
  String get widgetAccessEraser => 'Access Eraser';

  @override
  String get widgetQuickNotes => 'Quick Notes';

  @override
  String get widgetReport => 'Report';

  @override
  String get widgetPersonalTimeTracking => 'Personal Time Tracking';

  @override
  String get widgetTimeTrackingReport => 'Time Tracking Report';

  @override
  String get widgetWorkItemExporter => 'Work Item Exporter';
}
