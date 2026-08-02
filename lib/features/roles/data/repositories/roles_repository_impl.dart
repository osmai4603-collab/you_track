import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/roles/data/datasources/roles_remote_data_source.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';

class RolesRepositoryImpl implements RolesRepository {
  final RolesRemoteDataSource dataSource;

  RolesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<RoleEntity>>> getRoles() async {
    try {
      final roles = await dataSource.getRoles();
      return Right(roles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> getRoleByName(String name) async {
    try {
      final role = await dataSource.getRoleByName(name);
      return Right(role);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> createRole(RoleEntity role) async {
    try {
      final created = await dataSource.createRole({'name': role.name, 'description': role.description, 'permissions': role.permissions});
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> updateRole(RoleEntity role) async {
    try {
      final updated = await dataSource.updateRole(role.name, {'name': role.name, 'description': role.description, 'permissions': role.permissions});
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRole(String name) async {
    try {
      await dataSource.deleteRole(name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
