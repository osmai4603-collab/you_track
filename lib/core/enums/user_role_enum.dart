import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class UserRoleEnum extends AppEnum {
  const UserRoleEnum();

  static const contributor = ContributorRole._();
  static const projectAdmin = ProjectAdminRole._();
  static const systemAdmin = SystemAdminRole._();

  static List<UserRoleEnum> get values =>
      [contributor, projectAdmin, systemAdmin];

  static UserRoleEnum of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown UserRoleEnum: $name'),
    );
  }
}

final class ContributorRole extends UserRoleEnum {
  const ContributorRole._();

  @override
  String get name => 'contributor';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) =>
      localization.roleContributor;
}

final class ProjectAdminRole extends UserRoleEnum {
  const ProjectAdminRole._();

  @override
  String get name => 'project-admin';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) =>
      localization.roleProjectAdmin;
}

final class SystemAdminRole extends UserRoleEnum {
  const SystemAdminRole._();

  @override
  String get name => 'system-admin';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) =>
      localization.roleSystemAdmin;
}
