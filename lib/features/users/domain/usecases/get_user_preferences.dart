import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class GetUserPreferencesParams extends Params {
  final String userId;
  const GetUserPreferencesParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetUserPreferencesUseCase
    extends UseCase<UserPreferencesEntity, GetUserPreferencesParams> {
  final UserProfileRepository repository;
  GetUserPreferencesUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, UserPreferencesEntity>> call({
    required GetUserPreferencesParams params,
  }) {
    return repository.getUserPreferences(params.userId);
  }
}