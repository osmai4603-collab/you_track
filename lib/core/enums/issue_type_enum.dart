import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class IssueTypeEnum extends AppEnum {
  const IssueTypeEnum();

  static const bug = BugType._();
  static const cosmetic = CosmeticType._();
  static const exception = ExceptionType._();
  static const feature = FeatureType._();
  static const task = TaskType._();
  static const usabilityProblem = UsabilityProblemType._();
  static const performanceProblem = PerformanceProblemType._();
  static const epic = EpicType._();

  static List<IssueTypeEnum> get values => [
    bug,
    cosmetic,
    exception,
    feature,
    task,
    usabilityProblem,
    performanceProblem,
    epic,
  ];

  static IssueTypeEnum of(String name) {
    return values.firstWhere((e) => e.name == name, orElse: () => task);
  }
}

final class BugType extends IssueTypeEnum {
  const BugType._();

  @override
  String get name => 'bug';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) => localization.typeBug;
}

final class CosmeticType extends IssueTypeEnum {
  const CosmeticType._();

  @override
  String get name => 'cosmetic';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) =>
      localization.typeCosmetic;
}

final class ExceptionType extends IssueTypeEnum {
  const ExceptionType._();

  @override
  String get name => 'exception';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) =>
      localization.typeException;
}

final class FeatureType extends IssueTypeEnum {
  const FeatureType._();

  @override
  String get name => 'feature';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) => localization.typeFeature;
}

final class TaskType extends IssueTypeEnum {
  const TaskType._();

  @override
  String get name => 'task';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) => localization.typeTask;
}

final class UsabilityProblemType extends IssueTypeEnum {
  const UsabilityProblemType._();

  @override
  String get name => 'usability-problem';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) =>
      localization.typeUsabilityProblem;
}

final class PerformanceProblemType extends IssueTypeEnum {
  const PerformanceProblemType._();

  @override
  String get name => 'performance-problem';

  @override
  int get index => 6;

  @override
  String displayName(AppLocalizations localization) =>
      localization.typePerformanceProblem;
}

final class EpicType extends IssueTypeEnum {
  const EpicType._();

  @override
  String get name => 'epic';

  @override
  int get index => 7;

  @override
  String displayName(AppLocalizations localization) => localization.typeEpic;
}
