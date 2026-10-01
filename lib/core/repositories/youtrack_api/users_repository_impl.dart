import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/entities/user_role_assignment.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'api_failure_mapper.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/users_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersApi _api;

  UsersRepositoryImpl(this._api);

  @override
  Future<Either<Failure, UserEntity>> createUser(
    UserEntity user, {
    String? password,
  }) async {
    final result = await _api.createUser(_toJson(user), password: password);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_toEntity(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    final result = await _api.deleteUser(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    final result = await _api.getUserByID(id);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_toEntity(result.data));
  }

  @override
  Future<Either<Failure, UserPermissionsEntity>> getUserPermissions(
    String userId,
  ) async {
    final result = await _api.getMyPermissions();
    if (result.isFailure) {
      return Left(failureFromApiError(result.error));
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
    return _getUsers();
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    final result = await _api.updateUser(user.id, _toJson(user));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_toEntity(result.data));
  }

  Future<Either<Failure, List<UserEntity>>> _getUsers() async {
    final result = await _api.getUsers();
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_toEntity).toList(growable: false));
  }

  static UserEntity _toEntity(UserModel model) => UserEntity(
    id: model.id,
    fullName: model.fullName,
    username: model.username,
    email: model.email,
    avatarUrl: model.avatarUrl,
    createdAt: model.createdAt,
    isBanned: model.isBanned,
    groups: model.groups,
    projects: model.projects,
    initials: model.initials,
  );

  static JsonObject _toJson(UserEntity user) => {
    'id': user.id,
    'fullName': user.fullName,
    'username': user.username,
    'email': user.email,
    'avatarUrl': user.avatarUrl,
    'isBanned': user.isBanned,
  };
}
