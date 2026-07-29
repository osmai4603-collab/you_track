import 'package:flutter/foundation.dart';
import 'package:issues_tracking/features/auth/domain/entities/user_entity.dart';

class UserSession extends ChangeNotifier {
  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  void setUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
