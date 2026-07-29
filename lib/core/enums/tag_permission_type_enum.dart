import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class TagPermissionType extends AppEnum {
  const TagPermissionType();

  static const view = TagViewPermission._();
  static const use = TagUsePermission._();
  static const edit = TagEditPermission._();

  static List<TagPermissionType> get values => [
        view,
        use,
        edit,
      ];

  static TagPermissionType of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => view,
    );
  }
}

final class TagViewPermission extends TagPermissionType {
  const TagViewPermission._();

  @override
  String get name => 'view';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) => localization.tagPermissionView;
}

final class TagUsePermission extends TagPermissionType {
  const TagUsePermission._();

  @override
  String get name => 'use';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) => localization.tagPermissionUse;
}

final class TagEditPermission extends TagPermissionType {
  const TagEditPermission._();

  @override
  String get name => 'edit';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) => localization.tagPermissionEdit;
}
