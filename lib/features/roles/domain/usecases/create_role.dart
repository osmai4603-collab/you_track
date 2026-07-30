import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';

class CreateRoleParams extends Params {
  final String name;
  final String? description;
  final List<String> permissions;

  const CreateRoleParams({required this.name, this.description, required this.permissions});

  @override
  List<Object?> get props => [name, description, permissions];
}

class CreateRole extends UseCase<RoleEntity, CreateRoleParams> {
  final RolesRepository repository;

  CreateRole(this.repository);

  @override
  Future<Either<Failure, RoleEntity>> call({required CreateRoleParams params}) {
    return repository.createRole(
      RoleEntity(
        name: params.name,
        description: params.description,
        permissions: params.permissions,
      ),
    );
  }
}
