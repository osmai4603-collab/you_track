import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/custom_field_type_enum.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../../domain/usecases/add_custom_field_use_case.dart';
import '../../domain/usecases/delete_custom_fields_use_case.dart';
import '../../domain/usecases/get_custom_fields_use_case.dart';
import '../../domain/usecases/reorder_custom_fields_use_case.dart';
import '../../domain/usecases/update_custom_field_use_case.dart';
import '../../domain/usecases/update_field_visibility_use_case.dart';
import '../../domain/usecases/update_field_access_control_use_case.dart';
import '../../domain/usecases/replace_field_value_use_case.dart';

sealed class CustomFieldsState extends Equatable {
  const CustomFieldsState();

  @override
  List<Object?> get props => [];
}

final class CustomFieldsInitial extends CustomFieldsState {
  const CustomFieldsInitial();
}

final class CustomFieldsLoading extends CustomFieldsState {
  const CustomFieldsLoading();
}

final class CustomFieldsLoaded extends CustomFieldsState {
  final List<CustomFieldEntity> fields;
  final bool isSaving;

  const CustomFieldsLoaded({required this.fields, this.isSaving = false});

  @override
  List<Object?> get props => [fields, isSaving];
}

final class CustomFieldsError extends CustomFieldsState {
  final String message;
  const CustomFieldsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomFieldsCubit extends Cubit<CustomFieldsState> {
  final GetCustomFieldsUseCase _getFieldsUseCase;
  final AddCustomFieldUseCase _addFieldUseCase;
  final UpdateCustomFieldUseCase _updateFieldUseCase;
  final DeleteCustomFieldsUseCase _deleteFieldsUseCase;
  final ReorderCustomFieldsUseCase _reorderFieldsUseCase;
  final UpdateFieldVisibilityUseCase _updateVisibilityUseCase;
  final UpdateFieldAccessControlUseCase _updateAccessControlUseCase;
  final ReplaceFieldValueUseCase _replaceFieldValueUseCase;

  CustomFieldsCubit({
    required GetCustomFieldsUseCase getFieldsUseCase,
    required AddCustomFieldUseCase addFieldUseCase,
    required UpdateCustomFieldUseCase updateFieldUseCase,
    required DeleteCustomFieldsUseCase deleteFieldsUseCase,
    required ReorderCustomFieldsUseCase reorderFieldsUseCase,
    required UpdateFieldVisibilityUseCase updateVisibilityUseCase,
    required UpdateFieldAccessControlUseCase updateAccessControlUseCase,
    required ReplaceFieldValueUseCase replaceFieldValueUseCase,
  }) : _getFieldsUseCase = getFieldsUseCase,
       _addFieldUseCase = addFieldUseCase,
       _updateFieldUseCase = updateFieldUseCase,
       _deleteFieldsUseCase = deleteFieldsUseCase,
       _reorderFieldsUseCase = reorderFieldsUseCase,
       _updateVisibilityUseCase = updateVisibilityUseCase,
       _updateAccessControlUseCase = updateAccessControlUseCase,
       _replaceFieldValueUseCase = replaceFieldValueUseCase,
       super(const CustomFieldsInitial());

  Future<void> loadFields(String projectId) async {
    emit(const CustomFieldsLoading());
    final result = await _getFieldsUseCase(
      params: GetCustomFieldsParams(projectId: projectId),
    );
    result.fold(
      (failure) => emit(CustomFieldsError(failure.message)),
      (fields) => emit(CustomFieldsLoaded(fields: fields)),
    );
  }

  Future<void> addField({
    required String projectId,
    required String name,
    required CustomFieldEnumType fieldType,
    String? defaultValue,
  }) async {
    final current = state;
    if (current is CustomFieldsLoaded) {
      emit(CustomFieldsLoaded(fields: current.fields, isSaving: true));
    }
    final result = await _addFieldUseCase(
      params: AddCustomFieldParams(
        projectId: projectId,
        name: name,
        fieldType: fieldType,
        defaultValue: defaultValue,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
        emit(CustomFieldsError(failure.message));
      },
      (field) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(
            fields: [...s.fields, field],
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> updateField({
    required String fieldId,
    String? name,
    CustomFieldEnumType? fieldType,
    String? defaultValue,
  }) async {
    final current = state;
    if (current is CustomFieldsLoaded) {
      emit(CustomFieldsLoaded(fields: current.fields, isSaving: true));
    }
    final result = await _updateFieldUseCase(
      params: UpdateCustomFieldParams(
        fieldId: fieldId,
        name: name,
        fieldType: fieldType,
        defaultValue: defaultValue,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
        emit(CustomFieldsError(failure.message));
      },
      (field) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(
            fields:
                s.fields.map((f) => f.id == field.id ? field : f).toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> deleteFields(List<String> fieldIds) async {
    final current = state;
    if (current is CustomFieldsLoaded) {
      emit(CustomFieldsLoaded(fields: current.fields, isSaving: true));
    }
    final result = await _deleteFieldsUseCase(
      params: DeleteCustomFieldsParams(fieldIds: fieldIds),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
        emit(CustomFieldsError(failure.message));
      },
      (_) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(
            fields: s.fields.where((f) => !fieldIds.contains(f.id)).toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> reorderField({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  }) async {
    final current = state;
    if (current is! CustomFieldsLoaded) return;

    final reordered = List<CustomFieldEntity>.from(current.fields);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    emit(CustomFieldsLoaded(fields: reordered, isSaving: true));

    final result = await _reorderFieldsUseCase(
      params: ReorderCustomFieldsParams(
        projectId: projectId,
        oldIndex: oldIndex,
        newIndex: newIndex,
      ),
    );
    result.fold(
      (failure) {
        emit(CustomFieldsLoaded(fields: current.fields, isSaving: false));
        emit(CustomFieldsError(failure.message));
      },
      (_) {
        emit(CustomFieldsLoaded(fields: reordered, isSaving: false));
      },
    );
  }

  Future<void> updateVisibility({
    required String fieldId,
    required String visibility,
  }) async {
    final current = state;
    if (current is CustomFieldsLoaded) {
      emit(CustomFieldsLoaded(fields: current.fields, isSaving: true));
    }
    final result = await _updateVisibilityUseCase(
      params: UpdateFieldVisibilityParams(
        fieldId: fieldId,
        visibility: visibility,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
        emit(CustomFieldsError(failure.message));
      },
      (field) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(
            fields:
                s.fields.map((f) => f.id == field.id ? field : f).toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> updateAccessControl({
    required String fieldId,
    required Map<String, dynamic> accessControl,
  }) async {
    final current = state;
    if (current is CustomFieldsLoaded) {
      emit(CustomFieldsLoaded(fields: current.fields, isSaving: true));
    }
    final result = await _updateAccessControlUseCase(
      params: UpdateFieldAccessControlParams(
        fieldId: fieldId,
        accessControl: accessControl,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
        emit(CustomFieldsError(failure.message));
      },
      (field) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(
            fields:
                s.fields.map((f) => f.id == field.id ? field : f).toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> replaceFieldValue({
    required String fieldId,
    required String oldValue,
    required String newValue,
  }) async {
    final current = state;
    if (current is CustomFieldsLoaded) {
      emit(CustomFieldsLoaded(fields: current.fields, isSaving: true));
    }
    final result = await _replaceFieldValueUseCase(
      params: ReplaceFieldValueParams(
        fieldId: fieldId,
        oldValue: oldValue,
        newValue: newValue,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
        emit(CustomFieldsError(failure.message));
      },
      (_) {
        final s = state;
        if (s is CustomFieldsLoaded) {
          emit(CustomFieldsLoaded(fields: s.fields, isSaving: false));
        }
      },
    );
  }
}
