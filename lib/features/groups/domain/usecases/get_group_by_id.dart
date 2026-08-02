import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class GetGroupByIdParams extends Params {
  final String id;

  const GetGroupByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetGroupById extends UseCasePermission<GroupEntity, GetGroupByIdParams> {
  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminRead;

  final GroupsRepository repository;

  GetGroupById(this.repository);

  @override
  Future<Either<Failure, GroupEntity>> call({
    required GetGroupByIdParams params,
  }) {
    return repository.getGroupById(params.id);
  }
}
