import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/permission_guard_mixin.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class UpdateUserParams extends Params {
  final UserEntity user;
  const UpdateUserParams({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UseCasePermission<UserEntity, UpdateUserParams>
    with PermissionGuardMixin<UserEntity, UpdateUserParams> {
  final UsersRepository repository;
  UpdateUser(this.repository);

  @override
  Permission get requiredPermission => Permission.userUpdateUser;

  @override
  Future<Either<Failure, UserEntity>> call({required UpdateUserParams params}) {
    return runWithPermissionCheck(
      action: () async => repository.updateUser(params.user),
    );
  }
}
