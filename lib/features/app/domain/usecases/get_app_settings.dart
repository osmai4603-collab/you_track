import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';
import 'package:issues_tracking/features/app/domain/repositories/app_settings_repository.dart';

class GetAppSettings implements UseCase<AppSettingsEntity, NoParams> {
  final AppSettingsRepository repository;

  GetAppSettings(this.repository);

  @override
  Future<Either<Failure, AppSettingsEntity>> call({required NoParams params}) async {
    return await repository.getAppSettings();
  }
}
