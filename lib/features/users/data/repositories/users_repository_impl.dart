import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/users/data/datasources/users_remote_data_source.dart';
import 'package:issues_tracking/features/users/data/models/user_model.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource dataSource;

  UsersRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final users = await dataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    try {
      final user = await dataSource.getUserById(id);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUser(UserEntity user) async {
    try {
      final model = UserModel.fromEntity(user);
      final created = await dataSource.createUser(model.toJson());
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    try {
      final model = UserModel.fromEntity(user);
      final updated = await dataSource.updateUser(model.id, model.toJson());
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await dataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
