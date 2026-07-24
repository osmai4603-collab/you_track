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
