import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class GetUsers extends UseCasePermission<List<UserEntity>, NoParams> {
  final UsersRepository repository;

  GetUsers(this.repository);

  @override
  Permission get requiredPermission => .userReadUserDetails;

  @override
  Future<Either<Failure, List<UserEntity>>> call({
    required NoParams params,
  }) async {
    final result = await hasPermission();
    return result.fold((left) => Left(left), (right) async {
      return await repository.getUsers();
    });
  }
}
