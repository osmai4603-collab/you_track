import 'package:flutter/foundation.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';

class UserSession extends ChangeNotifier {
  UserEntity? _currentUser;
  UserPermissionsEntity? _permissions;

  UserEntity? get currentUser => _currentUser;
  UserPermissionsEntity? get permissions => _permissions;
  bool get isLoggedIn => _currentUser != null;

  void setUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  void setPermissions(UserPermissionsEntity permissions) {
    _permissions = permissions;
    notifyListeners();
  }

  bool hasPermission(Permission permission, {String? projectId}) {
    if (_permissions == null) return false;
    if (projectId != null) {
      return _permissions!.isProjectOwner(projectId) ||
             _permissions!.hasProjectPermission(projectId, permission);
    }
    return _permissions!.hasGlobalPermission(permission);
  }

  bool isProjectOwner(String projectId) {
    return _permissions?.isProjectOwner(projectId) ?? false;
  }

  void refreshPermissions(UserPermissionsEntity permissions) {
    _permissions = permissions;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _permissions = null;
    notifyListeners();
  }
}
