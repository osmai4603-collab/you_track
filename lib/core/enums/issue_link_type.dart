import 'package:issues_tracking/core/enums/app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class IssueLinkType extends AppEnum {
  const IssueLinkType();

  static const relatesTo = RelatesTo._();
  static const isRequiredFor = IsRequiredFor._();
  static const dependsOn = DependsOn._();
  static const isDuplicatedBy = IsDuplicatedBy._();
  static const duplicates = Duplicates._();
  static const parentFor = ParentFor._();
  static const subtaskOf = SubtaskOf._();

  static List<IssueLinkType> values = [
    relatesTo,
    isRequiredFor,
    dependsOn,
    isDuplicatedBy,
    duplicates,
    parentFor,
    subtaskOf,
  ];

  static IssueLinkType of(String name) {
    return values.firstWhere(
      (linkType) => linkType.name == name,
      orElse: () => throw UnimplementedError(' No Link Type for $name'),
    );
  }
}

final class RelatesTo extends IssueLinkType {
  const RelatesTo._();
  @override
  String displayName(AppLocalizations localization) {
    return localization.relatesToOption;
  }

  @override
  int get index => 0;

  @override
  String get name => 'relates-to';
}

final class IsRequiredFor extends IssueLinkType {
  const IsRequiredFor._();

  @override
  String displayName(AppLocalizations localization) {
    return localization.isRequiredForOption;
  }

  @override
  int get index => 1;

  @override
  String get name => 'is-required-for';
}

final class DependsOn extends IssueLinkType {
  const DependsOn._();

  @override
  String displayName(AppLocalizations localization) {
    return localization.dependsOnOption;
  }

  @override
  int get index => 2;

  @override
  String get name => 'depends-on';
}

final class IsDuplicatedBy extends IssueLinkType {
  const IsDuplicatedBy._();
  @override
  String displayName(AppLocalizations localization) {
    return localization.isDuplicatedByOption;
  }

  @override
  int get index => 3;

  @override
  String get name => 'is-duplicated-by';
}

final class Duplicates extends IssueLinkType {
  const Duplicates._();
  @override
  String displayName(AppLocalizations localization) {
    return localization.duplicatesOption;
  }

  @override
  int get index => 4;

  @override
  String get name => 'duplicates';
}

final class ParentFor extends IssueLinkType {
  const ParentFor._();
  @override
  String displayName(AppLocalizations localization) {
    return localization.parentForOption;
  }

  @override
  int get index => 5;

  @override
  String get name => 'parent-for';
}

final class SubtaskOf extends IssueLinkType {
  const SubtaskOf._();

  @override
  String displayName(AppLocalizations localization) {
    return localization.subtaskOfOption;
  }

  @override
  int get index => 6;

  @override
  String get name => 'subtask-of';
}
