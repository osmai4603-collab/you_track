import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class BanUserParams extends Params {
  final String userId;
  final bool isBanned;
  const BanUserParams({required this.userId, required this.isBanned});

  @override
  List<Object?> get props => [userId, isBanned];
}

class BanUser extends UseCase<UserEntity, BanUserParams> {
  final UsersRepository repository;
  BanUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call({required BanUserParams params}) async {
    final userResult = await repository.getUserById(params.userId);
    return userResult.fold(
      (failure) => Left(failure),
      (user) => repository.updateUser(user.copyWith(isBanned: params.isBanned)),
    );
  }
}
