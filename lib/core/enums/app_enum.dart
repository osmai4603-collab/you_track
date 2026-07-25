import 'package:issues_tracking/core/localization/app_localizations.dart';

abstract class AppEnum {
  const AppEnum();

  String get name;
  int get index;

  String displayName(AppLocalizations localization);

  @override
  String toString() {
    return name;
  }
}
