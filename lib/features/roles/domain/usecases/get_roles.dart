import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/roles/domain/entities/role_entity.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';

class GetRoles extends UseCasePermission<List<RoleEntity>, NoParams> {
  final RolesRepository repository;

  GetRoles(this.repository);

  @override
  Future<Either<Failure, List<RoleEntity>>> call({required NoParams params}) {
    return repository.getRoles();
  }
}
