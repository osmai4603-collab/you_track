import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class ProjectWidgetEnum extends AppEnum {
  const ProjectWidgetEnum();

  static const documentListWidget = DocumentListWidgetType._();
  static const issueList = IssueListType._();
  static const issueDistributionReport = IssueDistributionReportType._();
  static const calendarWidget = CalendarWidgetType._();
  static const issueActivityFeed = IssueActivityFeedType._();
  static const projectTeam = ProjectTeamType._();
  static const accessEraser = AccessEraserType._();
  static const quickNotes = QuickNotesType._();
  static const report = ReportType._();
  static const personalTimeTracking = PersonalTimeTrackingType._();
  static const timeTrackingReport = TimeTrackingReportType._();
  static const workItemExporter = WorkItemExporterType._();

  static List<ProjectWidgetEnum> get values => [
    documentListWidget,
    issueList,
    issueDistributionReport,
    calendarWidget,
    issueActivityFeed,
    projectTeam,
    accessEraser,
    quickNotes,
    report,
    personalTimeTracking,
    timeTrackingReport,
    workItemExporter,
  ];

  static ProjectWidgetEnum of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown ProjectWidgetEnum: $name'),
    );
  }
}

final class DocumentListWidgetType extends ProjectWidgetEnum {
  const DocumentListWidgetType._();

  @override
  String get name => 'document-list-widget';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetDocumentListWidget;
}

final class IssueListType extends ProjectWidgetEnum {
  const IssueListType._();

  @override
  String get name => 'issue-list';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) => localization.widgetIssueList;
}

final class IssueDistributionReportType extends ProjectWidgetEnum {
  const IssueDistributionReportType._();

  @override
  String get name => 'issue-distribution-report';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetIssueDistributionReport;
}

final class CalendarWidgetType extends ProjectWidgetEnum {
  const CalendarWidgetType._();

  @override
  String get name => 'calendar-widget';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetCalendarWidget;
}

final class IssueActivityFeedType extends ProjectWidgetEnum {
  const IssueActivityFeedType._();

  @override
  String get name => 'issue-activity-feed';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetIssueActivityFeed;
}

final class ProjectTeamType extends ProjectWidgetEnum {
  const ProjectTeamType._();

  @override
  String get name => 'project-team';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetProjectTeam;
}

final class AccessEraserType extends ProjectWidgetEnum {
  const AccessEraserType._();

  @override
  String get name => 'access-eraser';

  @override
  int get index => 6;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetAccessEraser;
}

final class QuickNotesType extends ProjectWidgetEnum {
  const QuickNotesType._();

  @override
  String get name => 'quick-notes';

  @override
  int get index => 7;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetQuickNotes;
}

final class ReportType extends ProjectWidgetEnum {
  const ReportType._();

  @override
  String get name => 'report';

  @override
  int get index => 8;

  @override
  String displayName(AppLocalizations localization) => localization.widgetReport;
}

final class PersonalTimeTrackingType extends ProjectWidgetEnum {
  const PersonalTimeTrackingType._();

  @override
  String get name => 'personal-time-tracking';

  @override
  int get index => 9;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetPersonalTimeTracking;
}

final class TimeTrackingReportType extends ProjectWidgetEnum {
  const TimeTrackingReportType._();

  @override
  String get name => 'time-tracking-report';

  @override
  int get index => 10;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetTimeTrackingReport;
}

final class WorkItemExporterType extends ProjectWidgetEnum {
  const WorkItemExporterType._();

  @override
  String get name => 'work-item-exporter';

  @override
  int get index => 11;

  @override
  String displayName(AppLocalizations localization) =>
      localization.widgetWorkItemExporter;
}
