import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';

import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';

class UpdateRoleParams extends Params {
  final String name;
  final String? description;
  final List<String> permissions;

  const UpdateRoleParams({
    required this.name,
    this.description,
    required this.permissions,
  });

  @override
  List<Object?> get props => [name, description, permissions];
}

class UpdateRole extends UseCase<RoleEntity, UpdateRoleParams> {
  final RolesRepository repository;

  UpdateRole(this.repository);

  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  @override
  Future<Either<Failure, RoleEntity>> call({required UpdateRoleParams params}) {
    return repository.updateRole(
      RoleEntity(
        name: params.name,
        description: params.description,
        permissions: params.permissions,
      ),
    );
  }
}
