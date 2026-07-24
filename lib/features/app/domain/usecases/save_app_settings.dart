import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/app/domain/entities/app_settings_entity.dart';
import 'package:issues_tracking/features/app/domain/repositories/app_settings_repository.dart';

class SaveAppSettingsParams extends Params {
  final AppSettingsEntity settings;
  const SaveAppSettingsParams(this.settings);
  @override
  List<Object?> get props => [settings];
}

class SaveAppSettings implements UseCase<void, SaveAppSettingsParams> {
  final AppSettingsRepository repository;

  SaveAppSettings(this.repository);

  @override
  Future<Either<Failure, void>> call({required SaveAppSettingsParams params}) async {
    return await repository.saveAppSettings(params.settings);
  }
}
