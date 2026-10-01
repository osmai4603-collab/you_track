import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<Either<Failure, AppSettingsEntity>> getAppSettings();
  Future<Either<Failure, void>> saveAppSettings(AppSettingsEntity settings);
}
