import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:issues_tracking/features/groups/data/models/group_model.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource dataSource;

  GroupsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups() async {
    try {
      final groups = await dataSource.getGroups();
      return Right(groups);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String id) async {
    try {
      final group = await dataSource.getGroupById(id);
      return Right(group);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) async {
    try {
      final model = GroupModel.fromEntity(group);
      final created = await dataSource.createGroup(model.toJson());
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup(GroupEntity group) async {
    try {
      final model = GroupModel.fromEntity(group);
      final updated = await dataSource.updateGroup(model.id, model.toJson());
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String id) async {
    try {
      await dataSource.deleteGroup(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
