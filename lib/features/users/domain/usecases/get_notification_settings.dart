import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class GetNotificationSettingsParams extends Params {
  final String userId;
  const GetNotificationSettingsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetNotificationSettingsUseCase
    extends UseCase<NotificationSettingsEntity, GetNotificationSettingsParams> {
  final UserProfileRepository repository;
  GetNotificationSettingsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, NotificationSettingsEntity>> call({
    required GetNotificationSettingsParams params,
  }) {
    return repository.getNotificationSettings(params.userId);
  }
}