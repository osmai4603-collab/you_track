import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/core/repositories/abstractions/roles_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class RolesRepositoryImpl implements RolesRepository {
  final RolesApi _api;

  RolesRepositoryImpl(this._api);

  @override
  Future<Either<Failure, RoleEntity>> createRole(RoleEntity role) async {
    final result = await _api.createRole(_toJson(role));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fromJson(result.data));
  }

  @override
  Future<Either<Failure, void>> deleteRole(String name) async {
    final result = await _api.deleteRole(name);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Future<Either<Failure, RoleEntity>> getRoleByName(String name) async {
    final result = await _api.getRole(name);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fromJson(result.data));
  }

  @override
  Future<Either<Failure, List<RoleEntity>>> getRoles() async {
    final result = await _api.getRoles();
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(result.data.map(_fromJson).toList(growable: false));
  }

  @override
  Future<Either<Failure, RoleEntity>> updateRole(RoleEntity role) async {
    final result = await _api.updateRole(role.name, _toJson(role));
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(_fromJson(result.data));
  }
}

RoleEntity _fromJson(JsonObject json) => RoleEntity(
  name: (json['name'] ?? json['id'] ?? '').toString(),
  description: json['description']?.toString(),
  permissions: json['permissions'] is List
      ? (json['permissions'] as List).map((value) => value.toString()).toList()
      : const [],
);

JsonObject _toJson(RoleEntity role) => {
  'name': role.name,
  'description': role.description,
  'permissions': role.permissions,
};
