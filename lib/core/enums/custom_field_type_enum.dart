import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class CustomFieldEnumType extends AppEnum {
  const CustomFieldEnumType();

  static const build = BuildCustomFieldEnumType._();
  static const enumField = EnumCustomFieldEnumType._();
  static const group = GroupCustomFieldEnumType._();
  static const ownedField = OwnedFieldCustomFieldEnumType._();
  static const state = StateCustomFieldEnumType._();
  static const user = UserCustomFieldEnumType._();
  static const version = VersionCustomFieldEnumType._();
  static const date = DateCustomFieldEnumType._();
  static const dateTime = DateTimeCustomFieldEnumType._();
  static const float = FloatCustomFieldEnumType._();
  static const integer = IntegerCustomFieldEnumType._();
  static const string = StringCustomFieldEnumType._();
  static const text = TextCustomFieldEnumType._();
  static const period = PeriodCustomFieldEnumType._();

  static List<CustomFieldEnumType> get values => [
    build,
    enumField,
    group,
    ownedField,
    state,
    user,
    version,
    date,
    dateTime,
    float,
    integer,
    string,
    text,
    period,
  ];

  static CustomFieldEnumType of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown CustomFieldEnumType: $name'),
    );
  }

  static CustomFieldEnumType fromValue(String value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown CustomFieldEnumType: $value'),
    );
  }

  String get value;
}

final class BuildCustomFieldEnumType extends CustomFieldEnumType {
  const BuildCustomFieldEnumType._();

  @override
  String get name => 'build';

  @override
  int get index => 0;

  @override
  String get value => 'build';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeBuild;
}

final class EnumCustomFieldEnumType extends CustomFieldEnumType {
  const EnumCustomFieldEnumType._();

  @override
  String get name => 'enum';

  @override
  int get index => 1;

  @override
  String get value => 'enum';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeEnum;
}

final class GroupCustomFieldEnumType extends CustomFieldEnumType {
  const GroupCustomFieldEnumType._();

  @override
  String get name => 'group';

  @override
  int get index => 2;

  @override
  String get value => 'group';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeGroup;
}

final class OwnedFieldCustomFieldEnumType extends CustomFieldEnumType {
  const OwnedFieldCustomFieldEnumType._();

  @override
  String get name => 'ownedField';

  @override
  int get index => 3;

  @override
  String get value => 'owned-field';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeOwnedField;
}

final class StateCustomFieldEnumType extends CustomFieldEnumType {
  const StateCustomFieldEnumType._();

  @override
  String get name => 'state';

  @override
  int get index => 4;

  @override
  String get value => 'state';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeState;
}

final class UserCustomFieldEnumType extends CustomFieldEnumType {
  const UserCustomFieldEnumType._();

  @override
  String get name => 'user';

  @override
  int get index => 5;

  @override
  String get value => 'user';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeUser;
}

final class VersionCustomFieldEnumType extends CustomFieldEnumType {
  const VersionCustomFieldEnumType._();

  @override
  String get name => 'version';

  @override
  int get index => 6;

  @override
  String get value => 'version';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeVersion;
}

final class DateCustomFieldEnumType extends CustomFieldEnumType {
  const DateCustomFieldEnumType._();

  @override
  String get name => 'date';

  @override
  int get index => 7;

  @override
  String get value => 'date';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeDate;
}

final class DateTimeCustomFieldEnumType extends CustomFieldEnumType {
  const DateTimeCustomFieldEnumType._();

  @override
  String get name => 'dateTime';

  @override
  int get index => 8;

  @override
  String get value => 'date-time';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeDateTime;
}

final class FloatCustomFieldEnumType extends CustomFieldEnumType {
  const FloatCustomFieldEnumType._();

  @override
  String get name => 'float';

  @override
  int get index => 9;

  @override
  String get value => 'float';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeFloat;
}

final class IntegerCustomFieldEnumType extends CustomFieldEnumType {
  const IntegerCustomFieldEnumType._();

  @override
  String get name => 'integer';

  @override
  int get index => 10;

  @override
  String get value => 'integer';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeInteger;
}

final class StringCustomFieldEnumType extends CustomFieldEnumType {
  const StringCustomFieldEnumType._();

  @override
  String get name => 'string';

  @override
  int get index => 11;

  @override
  String get value => 'string';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeString;
}

final class TextCustomFieldEnumType extends CustomFieldEnumType {
  const TextCustomFieldEnumType._();

  @override
  String get name => 'text';

  @override
  int get index => 12;

  @override
  String get value => 'text';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypeText;
}

final class PeriodCustomFieldEnumType extends CustomFieldEnumType {
  const PeriodCustomFieldEnumType._();

  @override
  String get name => 'period';

  @override
  int get index => 13;

  @override
  String get value => 'period';

  @override
  String displayName(AppLocalizations localization) =>
      localization.customFieldEnumTypePeriod;
}
