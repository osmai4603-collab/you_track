import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/core/entities/user_permissions_entity.dart';
import 'package:youtrack_frontend/features/users/domain/entities/user_entity.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, UserEntity>> getUserById(String id);
  Future<Either<Failure, UserEntity>> createUser(
    UserEntity user, {
    String? password,
  });
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, UserPermissionsEntity>> getUserPermissions(
    String userId,
  );
}
