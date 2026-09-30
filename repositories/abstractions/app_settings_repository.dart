import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/app/domain/entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<Either<Failure, AppSettingsEntity>> getAppSettings();
  Future<Either<Failure, void>> saveAppSettings(AppSettingsEntity settings);
}
