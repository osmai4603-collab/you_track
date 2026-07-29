import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/roles/data/datasources/roles_remote_data_source.dart';
import 'package:issues_tracking/features/roles/data/models/role_model.dart';
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
  Future<Either<Failure, RoleEntity>> getRoleById(String id) async {
    try {
      final role = await dataSource.getRoleById(id);
      return Right(role);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> createRole(RoleEntity role) async {
    try {
      final model = RoleModel.fromEntity(role);
      final created = await dataSource.createRole(model.toJson());
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> updateRole(RoleEntity role) async {
    try {
      final model = RoleModel.fromEntity(role);
      final updated = await dataSource.updateRole(model.id, model.toJson());
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRole(String id) async {
    try {
      await dataSource.deleteRole(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
