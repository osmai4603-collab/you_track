import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class GetUsers extends UseCase<List<UserEntity>, NoParams> {
  final UsersRepository repository;

  GetUsers(this.repository);

  @override
  Permission get requiredPermission => .userReadUserBasic;

  @override
  Future<Either<Failure, List<UserEntity>>> call({
    NoParams params = const NoParams(),
  }) {
    return repository.getUsers();
  }
}
