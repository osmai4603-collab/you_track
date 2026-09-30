import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/entities/user_permissions_entity.dart';
import 'package:youtrack_frontend/core/entities/user_role_assignment.dart';
import 'package:youtrack_frontend/core/enums/permission_enum.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/users/domain/entities/user_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/users_repository.dart';
import 'package:youtrack_api/src/api/users_api.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersApi _api;

  UsersRepositoryImpl(this._api);

  @override
  Future<Either<Failure, UserEntity>> createUser(
    UserEntity user, {
    String? password,
  }) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserPermissionsEntity>> getUserPermissions(
    String userId,
  ) async {
    final result = await _api.getMyPermissions();
    if (result.isFailure) {
      return Left(ServerFailure(result.error.toString()));
    }

    return Right(
      UserPermissionsEntity(
        roleAssignments: result.data.roleAssignments
            .map(
              (assignment) => UserRoleAssignment(
                roleName: assignment.roleName,
                permissions: _parsePermissions(assignment.permissions),
                projectId: assignment.projectId,
                groupId: assignment.groupId,
              ),
            )
            .toList(growable: false),
        ownedProjectIds: result.data.ownedProjectIds,
      ),
    );
  }

  /// Drops permission names this build does not know about so a newer server
  /// cannot break the session with an unknown-value error.
  static List<Permission> _parsePermissions(List<String> names) {
    final known = Permission.values.map((e) => e.name).toSet();
    return names
        .where(known.contains)
        .map(Permission.of)
        .toList(growable: false);
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
