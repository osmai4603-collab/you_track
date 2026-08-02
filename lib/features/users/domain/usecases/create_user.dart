import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';

import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class CreateUserParams extends Params {
  final String displayName;
  final String email;
  final String password;

  const CreateUserParams({
    required this.displayName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [displayName, email, password];
}

class CreateUser extends UseCasePermission<UserEntity, CreateUserParams> {
  final UsersRepository repository;

  CreateUser(this.repository);

  @override
  Permission get requiredPermission => Permission.userCreateUser;

  @override
  Future<Either<Failure, UserEntity>> execute({required CreateUserParams params}) {
    return repository.createUser(
      UserEntity(
        id: '',
        fullName: params.displayName,
        username: params.email.split('@').first,
        email: params.email,
      ),
      password: params.password,
    );
  }
}
