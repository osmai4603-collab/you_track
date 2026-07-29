import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';

class UpdateRoleParams extends Params {
  final String id;
  final String name;
  final List<String> permissions;

  const UpdateRoleParams({
    required this.id,
    required this.name,
    required this.permissions,
  });

  @override
  List<Object?> get props => [id, name, permissions];
}

class UpdateRole extends UseCase<RoleEntity, UpdateRoleParams> {
  final RolesRepository repository;

  UpdateRole(this.repository);

  @override
  Future<Either<Failure, RoleEntity>> call({required UpdateRoleParams params}) {
    return repository.updateRole(
      RoleEntity(
        id: params.id,
        name: params.name,
        permissions: params.permissions,
      ),
    );
  }
}
