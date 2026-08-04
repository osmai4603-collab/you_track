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
  String get saveButton => 'Save';

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

  @override
  String get relatesToOption => 'Relates to';

  @override
  String get isRequiredForOption => 'Is required for';

  @override
  String get dependsOnOption => 'Depends on';

  @override
  String get isDuplicatedByOption => 'Is duplicated by';

  @override
  String get duplicatesOption => 'Duplicates';

  @override
  String get parentForOption => 'Parent for';

  @override
  String get subtaskOfOption => 'Subtask of';

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
  String get templateDefault => 'Default';

  @override
  String get templateScrum => 'Scrum';

  @override
  String get templateKanban => 'Kanban';

  @override
  String get templateTaskManagement => 'Task Management';

  @override
  String get templateHelpdesk => 'Helpdesk';

  @override
  String get templateProjectManagement => 'Project Management';

  @override
  String get templateDemo => 'Demo';

  @override
  String get templateMarketing => 'Marketing';

  @override
  String get permissionProjectReadProjectBasic => 'Project Basic';

  @override
  String get permissionProjectCreateProject => 'Project';

  @override
  String get permissionProjectReadProjectFull => 'Project Full';

  @override
  String get permissionProjectUpdateProject => 'Project';

  @override
  String get permissionProjectDeleteProject => 'Project';

  @override
  String get permissionOrganizationReadOrganization => 'Organization';

  @override
  String get permissionOrganizationUpdateOrganization => 'Organization';

  @override
  String get permissionOrganizationCreateOrganization => 'Organization';

  @override
  String get permissionOrganizationDeleteOrganization => 'Organization';

  @override
  String get permissionUserProfileUpdateSelf => 'Self Profile';

  @override
  String get permissionUserReadUserBasic => 'User Basic';

  @override
  String get permissionUserReadUserDetails => 'User Details';

  @override
  String get permissionUserUpdateUser => 'User';

  @override
  String get permissionUserCreateUser => 'User';

  @override
  String get permissionUserDeleteUser => 'User';

  @override
  String get permissionSystemLowLevelAdminRead => 'Low-Level Admin Settings';

  @override
  String get permissionSystemLowLevelAdminWrite => 'Low-Level Admin Settings';

  @override
  String get permissionIssueReadIssue => 'Issue';

  @override
  String get permissionIssueReadIssuePrivateFields => 'Issue Private Fields';

  @override
  String get permissionIssueUpdateIssue => 'Issue';

  @override
  String get permissionIssueCreateIssue => 'Issue';

  @override
  String get permissionIssueDeleteIssue => 'Issue';

  @override
  String get permissionIssueLinkIssues => 'Issues';

  @override
  String get permissionIssueUpdateIssuePrivateFields => 'Issue Private Fields';

  @override
  String get permissionIssueApplyCommandsSilently => 'Commands Silently';

  @override
  String get permissionIssueViewWatchers => 'Watchers';

  @override
  String get permissionIssueUpdateWatchers => 'Watchers';

  @override
  String get permissionIssueViewVoters => 'Voters';

  @override
  String get permissionAttachmentAddAttachment => 'Attachment';

  @override
  String get permissionAttachmentUpdateAttachment => 'Attachment';

  @override
  String get permissionAttachmentDeleteAttachment => 'Attachment';

  @override
  String get permissionCommentCreateIssueComment => 'Issue Comment';

  @override
  String get permissionCommentReadIssueComment => 'Issue Comment';

  @override
  String get permissionCommentUpdateIssueComment => 'Issue Comment';

  @override
  String get permissionCommentDeleteIssueComment => 'Issue Comment';

  @override
  String get permissionCommentUpdateNotOwnIssueComment =>
      'Not Own Issue Comment';

  @override
  String get permissionCommentDeleteNotOwnCommentAndPermanentCommentDelete =>
      'Not Own Comment & Permanent Delete';

  @override
  String get permissionCommentReadArticleComment => 'Article Comment';

  @override
  String get permissionCommentCreateArticleComment => 'Article Comment';

  @override
  String get permissionCommentUpdateArticleComment => 'Article Comment';

  @override
  String get permissionCommentDeleteArticleComment => 'Article Comment';

  @override
  String get permissionVisibilityOverrideVisibilityRestrictions =>
      'Visibility Restrictions';

  @override
  String get permissionIssueWorkItemReadWorkItem => 'Work Item';

  @override
  String get permissionIssueWorkItemUpdateWorkItem => 'Work Item';

  @override
  String get permissionIssueWorkItemUpdateNotOwnWorkItem => 'Not Own Work Item';

  @override
  String get permissionIssueWorkItemCreateWorkItem => 'Work Item';

  @override
  String get permissionIssueWorkItemCreateNotOwnWorkItem => 'Not Own Work Item';

  @override
  String get permissionArticleReadArticle => 'Article';

  @override
  String get permissionArticleCreateArticle => 'Article';

  @override
  String get permissionArticleUpdateArticle => 'Article';

  @override
  String get permissionArticleDeleteArticle => 'Article';

  @override
  String get permissionAppReadAppContent => 'App Content';

  @override
  String get permissionAppUpdateAppContent => 'App Content';

  @override
  String get customFieldsAddFieldToProject => 'Add field to project ...';

  @override
  String get customFieldsEditField => 'Edit Custom Field';

  @override
  String get customFieldsDeleteFields => 'Delete Custom Fields';

  @override
  String get customFieldsEmptyValue => 'Empty value (optional)';

  @override
  String get customFieldsCanBeEmpty => 'Can be empty';

  @override
  String get customFieldsValueMode => 'Value mode';

  @override
  String get customFieldsValueModeSingle => 'Single';

  @override
  String get customFieldsValueModeMulti => 'Multi';

  @override
  String get customFieldsAliases => 'Aliases (optional, comma-separated)';

  @override
  String get customFieldsFieldMode => 'Field mode';

  @override
  String get customFieldsVisibleTo => 'Visible to';

  @override
  String get customFieldsUpdatableBy => 'Updatable by';

  @override
  String get customFieldsShowOnlyWhen => 'Show only when';

  @override
  String get customFieldsFilterValuesBasedOn => 'Filter values based on';

  @override
  String get customFieldsAdvancedSettings => 'Advanced settings';

  @override
  String get customFieldsNoCustomFieldsYet => 'No custom fields yet';

  @override
  String get customFieldsFieldDetails => 'Field Details';

  @override
  String get customFieldsMakePublicSuccess =>
      'Field is now visible to everyone';

  @override
  String get customFieldsAccessControlUpdated => 'Access control updated';

  @override
  String customFieldsSelected(Object count) {
    return '$count selected';
  }

  @override
  String customFieldsDeleteConfirmation(Object count) {
    return 'Are you sure you want to delete $count custom field(s)?';
  }

  @override
  String get permissionDeniedTooltip =>
      'You don\'t have permission to perform this action';

  @override
  String get userProfileGeneral => 'General';

  @override
  String get userProfileWorkspace => 'Workspace';

  @override
  String get userProfileTagsAndSearches => 'Tags and Saved Searches';

  @override
  String get userProfileNotifications => 'Notifications';

  @override
  String get userProfileAccountSecurity => 'Account Security';

  @override
  String get fullName => 'Full name';

  @override
  String get username => 'Username';

  @override
  String get avatar => 'Avatar';

  @override
  String get vcsUsernames => 'VCS usernames';

  @override
  String get registrationDate => 'Registration date';

  @override
  String get personalData => 'Personal data';

  @override
  String get downloadCsv => 'Download in CSV format';

  @override
  String get localTimezone => 'Local time zone';

  @override
  String get guessTimezone => 'Guess time zone';

  @override
  String get sendTestMessage => 'Send test message';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSyncOs => 'Sync with OS';

  @override
  String get linksPanelPosition => 'Links panel position';

  @override
  String get belowSummary => 'Below the summary';

  @override
  String get belowDescription => 'Below the description';

  @override
  String get showRecentIssues => 'Show recent issues and articles';

  @override
  String get newTagOrSearch => 'New tag or saved search';

  @override
  String get delete => 'Delete';

  @override
  String get searchTagsAndSearches => 'Search tags and searches';

  @override
  String get all => 'All';

  @override
  String get createdByMe => 'Created by me';

  @override
  String get removeOnResolution => 'Remove on resolution';

  @override
  String get markAsFavorite => 'Mark as favorite for all viewers';

  @override
  String get notificationEvents => 'Notification events:';

  @override
  String get sendNotificationsTo => 'Send notifications to:';

  @override
  String get starAutomaticallyWhen => 'Star automatically when:';

  @override
  String get twoFactorAuth => 'Two-factor Authentication';

  @override
  String get credentials => 'Credentials';

  @override
  String get tokens => 'Tokens';

  @override
  String get changePassword => 'Change password';

  @override
  String get revokeRefreshToken => 'Revoke refresh token';

  @override
  String get deleteCredentials => 'Delete credentials';

  @override
  String get pairWithApp => 'Pair with app ...';

  @override
  String get pairWithHardwareToken => 'Pair with hardware token ...';

  @override
  String get addCredentials => 'Add credentials ...';

  @override
  String get newToken => 'New token ...';

  @override
  String get newPasswordButton => 'New password ...';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String passwordChangeFailed(Object error) {
    return 'Failed to change password: $error';
  }

  @override
  String get sessionsRevokedSuccess =>
      'Other active sessions have been revoked';

  @override
  String sessionsRevokeFailed(Object error) {
    return 'Failed to revoke sessions: $error';
  }

  @override
  String get changesSavedSuccess => 'Changes saved successfully';

  @override
  String get noTagSelected => 'No item selected to delete';

  @override
  String get enterTagName => 'Enter tag name...';

  @override
  String get enterSearchQuery => 'Enter search query...';

  @override
  String get searchSavedSearchType => 'Saved search';

  @override
  String get vcsUsernamesHint =>
      'Adding personal identifiers from integrated version control systems (VCS) lets YouTrack add links to issues referenced in your code commits.';

  @override
  String profileLoadError(Object error) {
    return 'Failed to load profile: $error';
  }

  @override
  String get changesByMe => 'Changes applied by me';

  @override
  String get mentionsMyUsername => '@mentions that reference my username';

  @override
  String get changesInDuplicateCluster => 'Changes in a duplicate cluster';

  @override
  String get issuesFromEmails => 'Issues and comments created from my emails';

  @override
  String get vcsBuildUpdates =>
      'Updates applied by VCS and build server integrations';

  @override
  String get failedVcsCommands =>
      'Failed commands in commits processed by VCS and build server integrations';

  @override
  String get starOnComment => 'I post a comment to an issue or article';

  @override
  String get starOnCreate => 'I create an issue or article';

  @override
  String get starOnUpdate => 'I update an issue or article';

  @override
  String get starOnAssigned => 'I am made responsible for an issue';

  @override
  String get starOnVote => 'I vote for an issue';

  @override
  String get emailChannel => 'Email';

  @override
  String get telegramChannel => 'YouTrack bot for Telegram';

  @override
  String get connectTelegramAccount => 'Connect my account';

  @override
  String get testMessageSent => 'Test message sent to email';

  @override
  String get downloadCsvStarted => 'Downloading personal data as CSV...';

  @override
  String timezoneGuessed(Object zone) {
    return 'Time zone guessed: $zone (based on IP address)';
  }
}
