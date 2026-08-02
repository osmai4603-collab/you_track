import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/custom_work_item_attribute_entity.dart';
import '../../domain/usecases/get_custom_work_item_attributes.dart';
import '../../domain/usecases/add_custom_work_item_attribute.dart';
import '../../domain/usecases/update_custom_work_item_attribute.dart';
import '../../domain/usecases/delete_custom_work_item_attribute.dart';

sealed class CustomAttributesState extends Equatable {
  const CustomAttributesState();

  @override
  List<Object?> get props => [];
}

final class CustomAttributesInitial extends CustomAttributesState {
  const CustomAttributesInitial();
}

final class CustomAttributesLoading extends CustomAttributesState {
  const CustomAttributesLoading();
}

final class CustomAttributesLoaded extends CustomAttributesState {
  final List<CustomWorkItemAttributeEntity> attributes;
  final bool isSaving;

  const CustomAttributesLoaded({required this.attributes, this.isSaving = false});

  @override
  List<Object?> get props => [attributes, isSaving];
}

final class CustomAttributesError extends CustomAttributesState {
  final String message;
  const CustomAttributesError(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomAttributesCubit extends Cubit<CustomAttributesState> {
  final GetCustomAttributes _getAttributesUseCase;
  final AddCustomAttribute _addAttributeUseCase;
  final UpdateCustomAttribute _updateAttributeUseCase;
  final DeleteCustomAttribute _deleteAttributeUseCase;
  final String projectId;

  CustomAttributesCubit({
    required this._getAttributesUseCase,
    required this._addAttributeUseCase,
    required this._updateAttributeUseCase,
    required this._deleteAttributeUseCase,
    required this.projectId,
  })  : super(const CustomAttributesInitial());

  Future<void> loadAttributes() async {
    emit(const CustomAttributesLoading());
    final result = await _getAttributesUseCase(
      params: GetCustomAttributesParams(projectId: projectId),
    );
    result.fold(
      (failure) => emit(CustomAttributesError(failure.message)),
      (attributes) => emit(CustomAttributesLoaded(attributes: attributes)),
    );
  }

  Future<void> addAttribute({
    required String name,
    required String fieldType,
    bool isRequired = false,
    List<String>? options,
  }) async {
    final current = state;
    if (current is CustomAttributesLoaded) {
      emit(CustomAttributesLoaded(attributes: current.attributes, isSaving: true));
    }
    final result = await _addAttributeUseCase(
      params: AddCustomAttributeParams(
        projectId: projectId,
        name: name,
        fieldType: fieldType,
        isRequired: isRequired,
        options: options,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomAttributesLoaded) {
          emit(CustomAttributesLoaded(attributes: s.attributes, isSaving: false));
        }
        emit(CustomAttributesError(failure.message));
      },
      (attribute) {
        final s = state;
        if (s is CustomAttributesLoaded) {
          emit(CustomAttributesLoaded(
            attributes: [...s.attributes, attribute],
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> updateAttribute({
    required String attributeId,
    String? name,
    String? fieldType,
    bool? isRequired,
    List<String>? options,
  }) async {
    final current = state;
    if (current is CustomAttributesLoaded) {
      emit(CustomAttributesLoaded(attributes: current.attributes, isSaving: true));
    }
    final result = await _updateAttributeUseCase(
      params: UpdateCustomAttributeParams(
        attributeId: attributeId,
        name: name,
        fieldType: fieldType,
        isRequired: isRequired,
        options: options,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomAttributesLoaded) {
          emit(CustomAttributesLoaded(attributes: s.attributes, isSaving: false));
        }
        emit(CustomAttributesError(failure.message));
      },
      (attribute) {
        final s = state;
        if (s is CustomAttributesLoaded) {
          emit(CustomAttributesLoaded(
            attributes: s.attributes
                .map((a) => a.id == attributeId ? attribute : a)
                .toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> deleteAttribute(String attributeId) async {
    final current = state;
    if (current is CustomAttributesLoaded) {
      emit(CustomAttributesLoaded(attributes: current.attributes, isSaving: true));
    }
    final result = await _deleteAttributeUseCase(
      params: DeleteCustomAttributeParams(attributeId: attributeId),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is CustomAttributesLoaded) {
          emit(CustomAttributesLoaded(attributes: s.attributes, isSaving: false));
        }
        emit(CustomAttributesError(failure.message));
      },
      (_) {
        final s = state;
        if (s is CustomAttributesLoaded) {
          emit(CustomAttributesLoaded(
            attributes: s.attributes.where((a) => a.id != attributeId).toList(),
            isSaving: false,
          ));
        }
      },
    );
  }
}
