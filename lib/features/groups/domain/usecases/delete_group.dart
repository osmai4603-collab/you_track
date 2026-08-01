import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/permission_guard_mixin.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class DeleteGroupParams extends Params {
  final String id;

  const DeleteGroupParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteGroup extends UseCasePermission<void, DeleteGroupParams>
    with PermissionGuardMixin<void, DeleteGroupParams> {
  final GroupsRepository repository;

  DeleteGroup(this.repository);

  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  @override
  Future<Either<Failure, void>> call({required DeleteGroupParams params}) {
    return runWithPermissionCheck(
      action: () async => repository.deleteGroup(params.id),
    );
  }
}
