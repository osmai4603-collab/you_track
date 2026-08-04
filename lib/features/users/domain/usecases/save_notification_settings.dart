import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class SaveNotificationSettingsParams extends Params {
  final NotificationSettingsEntity settings;
  const SaveNotificationSettingsParams({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class SaveNotificationSettingsUseCase
    extends UseCase<NotificationSettingsEntity, SaveNotificationSettingsParams> {
  final UserProfileRepository repository;
  SaveNotificationSettingsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, NotificationSettingsEntity>> call({
    required SaveNotificationSettingsParams params,
  }) {
    return repository.saveNotificationSettings(params.settings);
  }
}