import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/validate_custom_field_name.dart';
import '../../../domain/usecases/create_custom_field.dart';
import '../../../domain/entities/field_type.dart';

part 'form_state_state.dart';

class FormStateCubit extends Cubit<FormStateState> {
  final ValidateCustomFieldName validateFieldName;
  final CreateCustomField createCustomField;

  FormStateCubit({
    required this.validateFieldName,
    required this.createCustomField,
  }) : super(FormStateState.initial());

  void updateFieldName(String name) {
    emit(state.copyWith(fieldName: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateType(FieldType type) {
    emit(state.copyWith(type: type));
  }

  void updateIsPrivate(bool isPrivate) {
    emit(state.copyWith(isPrivate: isPrivate));
  }

  Future<void> submit(String projectId) async {
    if (state.fieldName.isEmpty) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      final isUnique = await validateFieldName.call(
        projectId: projectId,
        name: state.fieldName,
      );
      if (!isUnique) {
        emit(state.copyWith(isSubmitting: false, error: 'Field name already exists'));
        return;
      }
      await createCustomField.call(
        projectId: projectId,
        name: state.fieldName,
        description: state.description.isEmpty ? null : state.description,
        type: state.type,
        isPrivate: state.isPrivate,
      );
      emit(state.copyWith(isSubmitting: false, isSubmitted: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}