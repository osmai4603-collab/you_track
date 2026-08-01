import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/errors/failure.dart';

abstract class UserPermissionsRepository {
  Future<Either<Failure, UserPermissionsEntity>> getUserPermissions(String userId);
}
