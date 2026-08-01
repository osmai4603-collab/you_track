import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class DeleteUserParams extends Params {
  final String userId;
  const DeleteUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteUser extends UseCasePermission<void, DeleteUserParams> {
  final UsersRepository repository;
  DeleteUser(this.repository);

  @override
  Future<Either<Failure, void>> call({required DeleteUserParams params}) {
    return repository.deleteUser(params.userId);
  }
}
