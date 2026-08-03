import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class UpdateUserParams extends Params {
  final UserEntity user;
  const UpdateUserParams({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UseCase<UserEntity, UpdateUserParams> {
  final UsersRepository repository;
  UpdateUser(this.repository);

  @override
  Permission get requiredPermission => Permission.userUpdateUser;

  @override
  Future<Either<Failure, UserEntity>> call({required UpdateUserParams params}) {
    return repository.updateUser(params.user);
  }
}
