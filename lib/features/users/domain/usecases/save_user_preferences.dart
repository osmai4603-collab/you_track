import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class SaveUserPreferencesParams extends Params {
  final UserPreferencesEntity preferences;
  const SaveUserPreferencesParams({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}

class SaveUserPreferencesUseCase
    extends UseCase<UserPreferencesEntity, SaveUserPreferencesParams> {
  final UserProfileRepository repository;
  SaveUserPreferencesUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, UserPreferencesEntity>> call({
    required SaveUserPreferencesParams params,
  }) {
    return repository.saveUserPreferences(params.preferences);
  }
}