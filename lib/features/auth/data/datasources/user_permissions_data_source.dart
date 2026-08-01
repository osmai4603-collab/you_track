import 'package:issues_tracking/features/auth/data/models/user_permissions_model.dart';

abstract class UserPermissionsDataSource {
  Future<UserPermissionsModel> getUserPermissions(String userId);
}
