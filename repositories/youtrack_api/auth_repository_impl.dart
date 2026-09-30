import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/entities/user_token.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/auth_repository.dart';
import 'package:youtrack_api/src/models/user_model.dart';
import 'package:youtrack_api/src/youtrack_client.dart';
import 'package:youtrack_frontend/features/users/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final YoutrackClient _client;
  AuthRepositoryImpl(this._client);

  UserEntity _toEntity(UserModel user) => UserEntity(
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    avatarUrl: user.avatarUrl,
    isBanned: user.isBanned,
    createdAt: user.createdAt,
    groups: user.groups,
    initials: user.initials,
    projects: user.projects,
    username: user.username,
  );

  @override
  Future<Either<Failure, UserToken>> login(
    String login,
    String password,
  ) async {
    final result = await _client.login(login, password);
    if (result.isSuccess) {
      final entity = UserToken(
        accessToken: result.data.accessToken,
        refreshToken: result.data.refreshToken,
        tokenType: result.data.tokenType,
        expiresIn: result.data.expiresIn,
        user: _toEntity(result.data.user),
      );
      return Right(entity);
    }
    return Left(LocalDatabaseFailure(result.error.toString()));
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    final result = await _client.logout();
    if (result.isSuccess) {
      return Right(true);
    }
    return Left(LocalDatabaseFailure(result.error.toString()));
  }

  @override
  Future<Either<Failure, UserToken>> refreshToken() async {
    final result = await _client.refreshToken();
    if (result.isSuccess) {
      final entity = UserToken(
        accessToken: result.data.accessToken,
        refreshToken: result.data.refreshToken,
        tokenType: result.data.tokenType,
        expiresIn: result.data.expiresIn,
        user: _toEntity(result.data.user),
      );
      return Right(entity);
    }
    return Left(LocalDatabaseFailure(result.error.toString()));
  }
}
