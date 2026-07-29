import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class TagPermissionScope extends AppEnum {
  const TagPermissionScope();

  static const owner = TagOwnerScope._();
  static const admin = TagAdminScope._();
  static const developer = TagDeveloperScope._();
  static const viewer = TagViewerScope._();
  static const allMembers = TagAllMembersScope._();
  static const specificUsers = TagSpecificUsersScope._();

  static List<TagPermissionScope> get values => [
        owner,
        admin,
        developer,
        viewer,
        allMembers,
        specificUsers,
      ];

  static TagPermissionScope of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => allMembers,
    );
  }
}

final class TagOwnerScope extends TagPermissionScope {
  const TagOwnerScope._();

  @override
  String get name => 'owner';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) => localization.tagScopeOwner;
}

final class TagAdminScope extends TagPermissionScope {
  const TagAdminScope._();

  @override
  String get name => 'admin';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) => localization.tagScopeAdmin;
}

final class TagDeveloperScope extends TagPermissionScope {
  const TagDeveloperScope._();

  @override
  String get name => 'developer';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) => localization.tagScopeDeveloper;
}

final class TagViewerScope extends TagPermissionScope {
  const TagViewerScope._();

  @override
  String get name => 'viewer';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) => localization.tagScopeViewer;
}

final class TagAllMembersScope extends TagPermissionScope {
  const TagAllMembersScope._();

  @override
  String get name => 'all_members';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) => localization.tagScopeAllMembers;
}

final class TagSpecificUsersScope extends TagPermissionScope {
  const TagSpecificUsersScope._();

  @override
  String get name => 'specific_users';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) => localization.tagScopeSpecificUsers;
}
