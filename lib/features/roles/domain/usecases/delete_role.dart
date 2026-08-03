import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/roles/domain/repositories/roles_repository.dart';

class DeleteRoleParams extends Params {
  final String id;

  const DeleteRoleParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteRole extends UseCase<void, DeleteRoleParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  final RolesRepository repository;

  DeleteRole(this.repository);

  @override
  Future<Either<Failure, void>> call({required DeleteRoleParams params}) {
    return repository.deleteRole(params.id);
  }
}
