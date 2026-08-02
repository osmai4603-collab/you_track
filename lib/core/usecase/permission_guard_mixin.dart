import 'package:get_it/get_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

mixin PermissionGuardMixin<ReturnType, ParamsType> {
  Permission get requiredPermission;

  Future<Either<Failure, ReturnType>> runWithPermissionCheck({
    required Future<Either<Failure, ReturnType>> Function() action,
    Permission? permission,
  }) async {
    final userSession = GetIt.instance<UserSession>();

    if (userSession.currentUser == null) {
      return Left(
        const PermissionDeniedFailure('Current user session is not available'),
      );
    }

    final effectivePermission = permission ?? requiredPermission;
    if (!userSession.hasPermission(effectivePermission)) {
      return Left(
        PermissionDeniedFailure(
          'The current user does not have permission to execute this operation',
        ),
      );
    }

    return action();
  }
}
