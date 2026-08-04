import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class RevokeRefreshTokenParams extends Params {
  const RevokeRefreshTokenParams();
}

class RevokeRefreshTokenUseCase extends UseCase<void, RevokeRefreshTokenParams> {
  final UserProfileRepository repository;
  RevokeRefreshTokenUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, void>> call({
    required RevokeRefreshTokenParams params,
  }) {
    return repository.revokeRefreshToken();
  }
}