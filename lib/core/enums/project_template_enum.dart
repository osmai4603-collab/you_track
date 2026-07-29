import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class ProjectTemplateType extends AppEnum {
  const ProjectTemplateType();

  String get templateName;
  String get iconKey;
  String get description;
  Map<String, String> get defaultFields;

  static const defaultTemplate = DefaultTemplateType._();
  static const scrum = ScrumTemplateType._();
  static const kanban = KanbanTemplateType._();
  static const taskManagement = TaskManagementTemplateType._();
  static const helpdesk = HelpdeskTemplateType._();
  static const projectManagement = ProjectManagementTemplateType._();
  static const demo = DemoTemplateType._();
  static const marketing = MarketingTemplateType._();

  static List<ProjectTemplateType> get values => [
    taskManagement,
    scrum,
    kanban,
    helpdesk,
    projectManagement,
    defaultTemplate,
    demo,
    marketing,
  ];

  static ProjectTemplateType of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown ProjectTemplateEnum: $name'),
    );
  }
}

final class DefaultTemplateType extends ProjectTemplateType {
  const DefaultTemplateType._();

  @override
  String get name => 'default';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateDefault;

  @override
  String get templateName => 'Default';

  @override
  String get iconKey => 'folder';

  @override
  String get description =>
      'Standard issue tracking template with default system fields.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Normal',
    'Type': 'Task',
    'State': 'Submitted',
    'Assignee': 'Unassigned',
    'Subsystem': 'No Subsystem',
    'Fix Versions': 'Unscheduled',
    'Affected versions': 'Unknown',
    'Fixed in build': 'Next Build',
  };
}

final class ScrumTemplateType extends ProjectTemplateType {
  const ScrumTemplateType._();

  @override
  String get name => 'scrum';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateScrum;

  @override
  String get templateName => 'Scrum';

  @override
  String get iconKey => 'view_week';

  @override
  String get description =>
      'Scrum agile development template with sprints, backlog, and story points.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Normal',
    'Type': 'User Story',
    'State': 'Backlog',
    'Sprint': 'Sprint 1',
    'Story Points': '0',
  };
}

final class KanbanTemplateType extends ProjectTemplateType {
  const KanbanTemplateType._();

  @override
  String get name => 'kanban';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateKanban;

  @override
  String get templateName => 'Kanban';

  @override
  String get iconKey => 'view_kanban';

  @override
  String get description =>
      'Kanban continuous workflow management template with WIP limits.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Normal',
    'Type': 'Task',
    'State': 'To Do',
    'WIP Limit': '5',
  };
}

final class TaskManagementTemplateType extends ProjectTemplateType {
  const TaskManagementTemplateType._();

  @override
  String get name => 'task_management';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateTaskManagement;

  @override
  String get templateName => 'Task Management';

  @override
  String get iconKey => 'check_box';

  @override
  String get description =>
      'Simplified project management template for teams tracking simple tasks.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Normal',
    'Type': 'Task',
    'State': 'Open',
    'Due Date': 'Not Set',
  };
}

final class HelpdeskTemplateType extends ProjectTemplateType {
  const HelpdeskTemplateType._();

  @override
  String get name => 'helpdesk';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateHelpdesk;

  @override
  String get templateName => 'Helpdesk';

  @override
  String get iconKey => 'headset_mic';

  @override
  String get description => 'Customer support and ticket management template.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'High',
    'Type': 'Ticket',
    'State': 'New',
    'SLA': '24 Hours',
  };
}

final class ProjectManagementTemplateType extends ProjectTemplateType {
  const ProjectManagementTemplateType._();

  @override
  String get name => 'project_management';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateProjectManagement;

  @override
  String get templateName => 'Project Management';

  @override
  String get iconKey => 'account_tree';

  @override
  String get description =>
      'Comprehensive project management with milestones and dependencies.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Normal',
    'Type': 'Feature',
    'State': 'Planning',
  };
}

final class DemoTemplateType extends ProjectTemplateType {
  const DemoTemplateType._();

  @override
  String get name => 'demo';

  @override
  int get index => 6;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateDemo;

  @override
  String get templateName => 'Demo';

  @override
  String get iconKey => 'play_circle_outline';

  @override
  String get description =>
      'Sample template pre-filled with demo data for exploration.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Normal',
    'Type': 'Demo Issue',
    'State': 'Open',
  };
}

final class MarketingTemplateType extends ProjectTemplateType {
  const MarketingTemplateType._();

  @override
  String get name => 'marketing';

  @override
  int get index => 7;

  @override
  String displayName(AppLocalizations localization) =>
      localization.templateMarketing;

  @override
  String get templateName => 'Marketing';

  @override
  String get iconKey => 'campaign';

  @override
  String get description =>
      'Campaign tracking and content management template for marketing teams.';

  @override
  Map<String, String> get defaultFields => const {
    'Priority': 'Medium',
    'Type': 'Campaign',
    'State': 'Draft',
  };
}
