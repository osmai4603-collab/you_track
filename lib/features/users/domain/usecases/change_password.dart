import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class ChangePasswordParams extends Params {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class ChangePasswordUseCase extends UseCase<void, ChangePasswordParams> {
  final UserProfileRepository repository;
  ChangePasswordUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, void>> call({
    required ChangePasswordParams params,
  }) {
    return repository.changePassword(
      params.currentPassword,
      params.newPassword,
    );
  }
}