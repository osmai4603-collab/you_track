import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/roles/domain/entities/role_entity.dart';

abstract class RolesRepository {
  Future<Either<Failure, List<RoleEntity>>> getRoles();
  Future<Either<Failure, RoleEntity>> getRoleByName(String name);
  Future<Either<Failure, RoleEntity>> createRole(RoleEntity role);
  Future<Either<Failure, RoleEntity>> updateRole(RoleEntity role);
  Future<Either<Failure, void>> deleteRole(String name);
}
