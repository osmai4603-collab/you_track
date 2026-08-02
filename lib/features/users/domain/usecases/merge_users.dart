import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class MergeUsersParams extends Params {
  final String primaryUserId;
  final String secondaryUserId;
  const MergeUsersParams({
    required this.primaryUserId,
    required this.secondaryUserId,
  });

  @override
  List<Object?> get props => [primaryUserId, secondaryUserId];
}

class MergeUsers extends UseCasePermission<UserEntity, MergeUsersParams> {
  final UsersRepository repository;
  MergeUsers(this.repository);

  @override
  Permission get requiredPermission => .systemLowLevelAdminWrite;

  @override
  Future<Either<Failure, UserEntity>> execute({
    required MergeUsersParams params,
  }) async {
    final primaryResult = await repository.getUserById(params.primaryUserId);
    final secondaryResult = await repository.getUserById(
      params.secondaryUserId,
    );

    return primaryResult.fold(
      (failure) => Left(failure),
      (primary) => secondaryResult.fold((failure) => Left(failure), (
        secondary,
      ) async {
        final mergedGroups = {...primary.groups, ...secondary.groups}.toList();
        final mergedProjects = {
          ...primary.projects,
          ...secondary.projects,
        }.toList();

        final merged = primary.copyWith(
          groups: mergedGroups,
          projects: mergedProjects,
        );

        final updateResult = await repository.updateUser(merged);
        await repository.deleteUser(params.secondaryUserId);

        return updateResult;
      }),
    );
  }
}
