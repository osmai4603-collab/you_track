import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_user_permissions_use_case.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

mixin PermissionRefreshMixin {
  Future<void> refreshUserPermissions() async {
    final userSession = get_it<UserSession>();
    final userId = userSession.currentUser?.id;
    if (userId == null) return;

    final getPermissions = get_it<GetUserPermissionsUseCase>();
    final result = await getPermissions(
      params: GetUserPermissionsParams(userId: userId),
    );

    result.fold(
      (failure) {
        // Silently fail or log if needed
      },
      (permissions) {
        userSession.refreshPermissions(permissions);
      },
    );
  }
}
