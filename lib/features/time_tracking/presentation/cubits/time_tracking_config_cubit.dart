import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../custom_fields/domain/entities/custom_field_entity.dart';
import '../../domain/entities/time_tracking_config_entity.dart';
import '../../domain/usecases/get_available_period_fields.dart';
import '../../domain/usecases/get_time_tracking_config.dart';
import '../../domain/usecases/save_time_tracking_config.dart';

sealed class TimeTrackingConfigState extends Equatable {
  const TimeTrackingConfigState();

  @override
  List<Object?> get props => [];
}

final class TimeTrackingConfigInitial extends TimeTrackingConfigState {
  const TimeTrackingConfigInitial();
}

final class TimeTrackingConfigLoading extends TimeTrackingConfigState {
  const TimeTrackingConfigLoading();
}

final class TimeTrackingConfigLoaded extends TimeTrackingConfigState {
  final TimeTrackingConfigEntity config;
  final TimeTrackingConfigEntity? savedSnapshot;
  final bool isSaving;
  final bool hasChanges;
  final List<CustomFieldEntity> availableFields;

  const TimeTrackingConfigLoaded({
    required this.config,
    this.savedSnapshot,
    this.isSaving = false,
    this.hasChanges = false,
    this.availableFields = const [],
  });

  TimeTrackingConfigLoaded copyWith({
    TimeTrackingConfigEntity? config,
    TimeTrackingConfigEntity? savedSnapshot,
    bool? isSaving,
    bool? hasChanges,
    List<CustomFieldEntity>? availableFields,
  }) {
    return TimeTrackingConfigLoaded(
      config: config ?? this.config,
      savedSnapshot: savedSnapshot ?? this.savedSnapshot,
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
      availableFields: availableFields ?? this.availableFields,
    );
  }

  @override
  List<Object?> get props =>
      [config, savedSnapshot, isSaving, hasChanges, availableFields];
}

final class TimeTrackingConfigError extends TimeTrackingConfigState {
  final String message;
  const TimeTrackingConfigError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TimeTrackingConfigStale extends TimeTrackingConfigState {
  final String message;
  const TimeTrackingConfigStale(this.message);

  @override
  List<Object?> get props => [message];
}

final class TimeTrackingConfigSaved extends TimeTrackingConfigState {
  final TimeTrackingConfigEntity config;
  const TimeTrackingConfigSaved(this.config);

  @override
  List<Object?> get props => [config];
}

final class TimeTrackingConfigSaveError extends TimeTrackingConfigState {
  final String message;
  final TimeTrackingConfigEntity config;
  const TimeTrackingConfigSaveError(this.message, this.config);

  @override
  List<Object?> get props => [message, config];
}

class TimeTrackingConfigCubit extends Cubit<TimeTrackingConfigState> {
  final GetTimeTrackingConfig _getConfigUseCase;
  final SaveTimeTrackingConfig _saveConfigUseCase;
  final GetAvailablePeriodFields _getAvailablePeriodFieldsUseCase;

  TimeTrackingConfigCubit({
    required this._getConfigUseCase,
    required this._saveConfigUseCase,
    required this._getAvailablePeriodFieldsUseCase,
  })  : super(const TimeTrackingConfigInitial());

  Future<void> loadConfig(String projectId) async {
    emit(const TimeTrackingConfigLoading());
    final result = await _getConfigUseCase(
      params: GetTimeTrackingConfigParams(projectId: projectId),
    );
    result.fold(
      (failure) => emit(TimeTrackingConfigError(failure.message)),
      (config) async {
        final fieldsResult = await _getAvailablePeriodFieldsUseCase(
          params: GetAvailablePeriodFieldsParams(projectId: projectId),
        );
        final fields = fieldsResult.fold(
          (failure) => <CustomFieldEntity>[],
          (f) => f,
        );
        emit(TimeTrackingConfigLoaded(
          config: config,
          savedSnapshot: config,
          availableFields: fields,
        ));
      },
    );
  }

  void toggleEnabled() {
    final current = state;
    if (current is TimeTrackingConfigLoaded) {
      final updated = current.config.copyWith(enabled: !current.config.enabled);
      emit(current.copyWith(
        config: updated,
        hasChanges: true,
      ));
    }
  }

  void setEstimationField(String? fieldId) {
    final current = state;
    if (current is TimeTrackingConfigLoaded) {
      final updated = current.config.copyWith(estimationFieldId: fieldId);
      emit(current.copyWith(config: updated, hasChanges: true));
    }
  }

  void setSpentTimeField(String? fieldId) {
    final current = state;
    if (current is TimeTrackingConfigLoaded) {
      final updated = current.config.copyWith(spentTimeFieldId: fieldId);
      emit(current.copyWith(config: updated, hasChanges: true));
    }
  }

  void setAggregateSpentTime(bool value) {
    final current = state;
    if (current is TimeTrackingConfigLoaded) {
      final updated = current.config.copyWith(aggregateSpentTime: value);
      emit(current.copyWith(config: updated, hasChanges: true));
    }
  }

  void setAggregateEstimation(bool value) {
    final current = state;
    if (current is TimeTrackingConfigLoaded) {
      final updated = current.config.copyWith(aggregateEstimation: value);
      emit(current.copyWith(config: updated, hasChanges: true));
    }
  }

  Future<void> save() async {
    final current = state;
    if (current is! TimeTrackingConfigLoaded) return;

    emit(current.copyWith(isSaving: true));
    final result = await _saveConfigUseCase(
      params: SaveTimeTrackingConfigParams(config: current.config),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is TimeTrackingConfigLoaded) {
          emit(s.copyWith(isSaving: false));
        }
        emit(TimeTrackingConfigSaveError(failure.message, current.config));
      },
      (savedConfig) {
        emit(TimeTrackingConfigSaved(savedConfig));
        emit(TimeTrackingConfigLoaded(
          config: savedConfig,
          savedSnapshot: savedConfig,
          isSaving: false,
          hasChanges: false,
        ));
      },
    );
  }

  void discard() {
    final current = state;
    if (current is TimeTrackingConfigLoaded && current.savedSnapshot != null) {
      emit(TimeTrackingConfigLoaded(
        config: current.savedSnapshot!,
        savedSnapshot: current.savedSnapshot,
        hasChanges: false,
      ));
    }
  }

  void detectStale(String currentDbUpdatedAt) {
    final current = state;
    if (current is TimeTrackingConfigLoaded) {
      final savedUpdatedAt = current.savedSnapshot?.updatedAt.toIso8601String();
      if (savedUpdatedAt != null && savedUpdatedAt != currentDbUpdatedAt) {
        emit(const TimeTrackingConfigStale(
          'This configuration has been modified by another user. Please reload.',
        ));
      }
    }
  }
}
