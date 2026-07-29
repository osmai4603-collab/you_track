import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';

abstract class GroupsRepository {
  Future<Either<Failure, List<GroupEntity>>> getGroups();
  Future<Either<Failure, GroupEntity>> getGroupById(String id);
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group);
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group);
  Future<Either<Failure, void>> deleteGroup(String id);
}
