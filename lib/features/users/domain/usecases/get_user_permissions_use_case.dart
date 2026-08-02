import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/entities/user_permissions_entity.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/repositories/users_repository.dart';

class GetUserPermissionsParams extends Params {
  final String userId;

  const GetUserPermissionsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetUserPermissionsUseCase
    implements UseCase<UserPermissionsEntity, GetUserPermissionsParams> {
  final UsersRepository repository;

  GetUserPermissionsUseCase(this.repository);

  @override
  Future<Either<Failure, UserPermissionsEntity>> call({
    required GetUserPermissionsParams params,
  }) async {
    return await repository.getUserPermissions(params.userId);
  }
}
