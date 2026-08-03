import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class GetGroups extends UseCase<List<GroupEntity>, GetGroupsParams> {
  final GroupsRepository repository;

  GetGroups(this.repository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call({required GetGroupsParams params}) {
    return repository.getGroups(userId: params.userId);
  }
}

class GetGroupsParams extends Params {
  final String? userId;

  const GetGroupsParams({this.userId});

  @override
  List<Object?> get props => [userId];
}
