import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/roles/domain/entities/role_entity.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/roles_repository.dart';

class RolesRepositoryImpl implements RolesRepository {
  @override
  Future<Either<Failure, RoleEntity>> createRole(RoleEntity role) {
    // TODO: implement createRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteRole(String name) {
    // TODO: implement deleteRole
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, RoleEntity>> getRoleByName(String name) {
    // TODO: implement getRoleByName
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RoleEntity>>> getRoles() {
    // TODO: implement getRoles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, RoleEntity>> updateRole(RoleEntity role) {
    // TODO: implement updateRole
    throw UnimplementedError();
  }
}
