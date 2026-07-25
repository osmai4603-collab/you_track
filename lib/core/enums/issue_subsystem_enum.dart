import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class IssueSubsystemEnum extends AppEnum {
  const IssueSubsystemEnum();

  static const noValue = NoValueSubsystem._();
  static const issueTracking = IssueTrackingSubsystem._();
  static const projectManagement = ProjectManagementSubsystem._();
  static const migration = MigrationSubsystem._();

  static List<IssueSubsystemEnum> get values =>
      [noValue, issueTracking, projectManagement, migration];

  static IssueSubsystemEnum of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown IssueSubsystemEnum: $name'),
    );
  }
}

final class NoValueSubsystem extends IssueSubsystemEnum {
  const NoValueSubsystem._();

  @override
  String get name => 'no-value';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) =>
      localization.subsystemNoValue;
}

final class IssueTrackingSubsystem extends IssueSubsystemEnum {
  const IssueTrackingSubsystem._();

  @override
  String get name => 'issue-tracking';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) =>
      localization.subsystemIssueTracking;
}

final class ProjectManagementSubsystem extends IssueSubsystemEnum {
  const ProjectManagementSubsystem._();

  @override
  String get name => 'project-management';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) =>
      localization.subsystemProjectManagement;
}

final class MigrationSubsystem extends IssueSubsystemEnum {
  const MigrationSubsystem._();

  @override
  String get name => 'migration';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) =>
      localization.subsystemMigration;
}
