import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/entities/user_token.dart';
import 'package:issues_tracking/core/errors/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserToken>> login(String login, String password);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, UserToken>> refreshToken();
}
