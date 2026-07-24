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
}
