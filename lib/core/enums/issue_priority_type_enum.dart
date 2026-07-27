import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class IssuePriorityTypeEnum extends AppEnum {
  const IssuePriorityTypeEnum();

  static const showStopper = ShowStopperPriority._();
  static const critical = CriticalPriority._();
  static const major = MajorPriority._();
  static const normal = NormalPriority._();
  static const minor = MinorPriority._();

  static List<IssuePriorityTypeEnum> get values => [
    showStopper,
    critical,
    major,
    normal,
    minor,
  ];

  int get color;

  static IssuePriorityTypeEnum of(String name) {
    return values.firstWhere(
      (e) => e.name == name.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown IssuePriorityTypeEnum: $name'),
    );
  }
}

final class ShowStopperPriority extends IssuePriorityTypeEnum {
  const ShowStopperPriority._();

  @override
  String get name => 'show-stopper';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) =>
      localization.priorityShowStopper;

  @override
  int get color => 0xFFFF5252;
}

final class CriticalPriority extends IssuePriorityTypeEnum {
  const CriticalPriority._();

  @override
  String get name => 'critical';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) {
    return localization.priorityCritical;
  }

  @override
  int get color => 0xFFFF4081;
}

final class MajorPriority extends IssuePriorityTypeEnum {
  const MajorPriority._();

  @override
  String get name => 'major';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) {
    return localization.priorityMajor;
  }

  @override
  int get color => 0xFFFFAB40;
}

final class NormalPriority extends IssuePriorityTypeEnum {
  const NormalPriority._();

  @override
  String get name => 'normal';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) =>
      localization.priorityNormal;

  @override
  int get color => 0xFF607D8B;
}

final class MinorPriority extends IssuePriorityTypeEnum {
  const MinorPriority._();

  @override
  String get name => 'minor';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) {
    return localization.priorityMinor;
  }

  @override
  int get color => 0xFFBDBDBD;
}
