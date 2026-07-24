import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/app/data/datasources/app_settings_local_data_source.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';
import 'package:issues_tracking/features/app/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocalDataSource localDataSource;

  AppSettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, AppSettingsEntity>> getAppSettings() async {
    try {
      final settings = await localDataSource.getAppSettings();
      return Right(settings);
    } catch (e) {
      return const Left(LocalDatabaseFailure('فشل في جلب الإعدادات من الذاكرة المحلية'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAppSettings(AppSettingsEntity settings) async {
    try {
      await localDataSource.saveAppSettings(settings);
      return const Right(null);
    } catch (e) {
      return const Left(LocalDatabaseFailure('فشل في حفظ الإعدادات في الذاكرة المحلية'));
    }
  }
}
