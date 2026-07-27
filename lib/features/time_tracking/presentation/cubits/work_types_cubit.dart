import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/work_type_entity.dart';
import '../../domain/usecases/get_work_types.dart';
import '../../domain/usecases/add_work_type.dart';
import '../../domain/usecases/update_work_type.dart';
import '../../domain/usecases/delete_work_type.dart';
import '../../domain/usecases/reorder_work_types.dart';

sealed class WorkTypesState extends Equatable {
  const WorkTypesState();

  @override
  List<Object?> get props => [];
}

final class WorkTypesInitial extends WorkTypesState {
  const WorkTypesInitial();
}

final class WorkTypesLoading extends WorkTypesState {
  const WorkTypesLoading();
}

final class WorkTypesLoaded extends WorkTypesState {
  final List<WorkTypeEntity> workTypes;
  final bool isSaving;

  const WorkTypesLoaded({required this.workTypes, this.isSaving = false});

  @override
  List<Object?> get props => [workTypes, isSaving];
}

final class WorkTypesError extends WorkTypesState {
  final String message;
  const WorkTypesError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkTypesCubit extends Cubit<WorkTypesState> {
  final GetWorkTypes _getWorkTypesUseCase;
  final AddWorkType _addWorkTypeUseCase;
  final UpdateWorkType _updateWorkTypeUseCase;
  final DeleteWorkType _deleteWorkTypeUseCase;
  final ReorderWorkTypes _reorderWorkTypesUseCase;
  final String projectId;

  WorkTypesCubit({
    required GetWorkTypes getWorkTypesUseCase,
    required AddWorkType addWorkTypeUseCase,
    required UpdateWorkType updateWorkTypeUseCase,
    required DeleteWorkType deleteWorkTypeUseCase,
    required ReorderWorkTypes reorderWorkTypesUseCase,
    required this.projectId,
  })  : _getWorkTypesUseCase = getWorkTypesUseCase,
        _addWorkTypeUseCase = addWorkTypeUseCase,
        _updateWorkTypeUseCase = updateWorkTypeUseCase,
        _deleteWorkTypeUseCase = deleteWorkTypeUseCase,
        _reorderWorkTypesUseCase = reorderWorkTypesUseCase,
        super(const WorkTypesInitial());

  Future<void> loadWorkTypes() async {
    emit(const WorkTypesLoading());
    final result = await _getWorkTypesUseCase(
      params: GetWorkTypesParams(projectId: projectId),
    );
    result.fold(
      (failure) => emit(WorkTypesError(failure.message)),
      (workTypes) => emit(WorkTypesLoaded(workTypes: workTypes)),
    );
  }

  Future<void> addWorkType({
    required String name,
    String? description,
  }) async {
    final current = state;
    if (current is WorkTypesLoaded) {
      emit(WorkTypesLoaded(workTypes: current.workTypes, isSaving: true));
    }
    final result = await _addWorkTypeUseCase(
      params: AddWorkTypeParams(
        projectId: projectId,
        name: name,
        description: description,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is WorkTypesLoaded) {
          emit(WorkTypesLoaded(workTypes: s.workTypes, isSaving: false));
        }
        emit(WorkTypesError(failure.message));
      },
      (workType) {
        final s = state;
        if (s is WorkTypesLoaded) {
          emit(WorkTypesLoaded(
            workTypes: [...s.workTypes, workType],
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> updateWorkType({
    required String workTypeId,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    final current = state;
    if (current is WorkTypesLoaded) {
      emit(WorkTypesLoaded(workTypes: current.workTypes, isSaving: true));
    }
    final result = await _updateWorkTypeUseCase(
      params: UpdateWorkTypeParams(
        workTypeId: workTypeId,
        name: name,
        description: description,
        isActive: isActive,
      ),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is WorkTypesLoaded) {
          emit(WorkTypesLoaded(workTypes: s.workTypes, isSaving: false));
        }
        emit(WorkTypesError(failure.message));
      },
      (workType) {
        final s = state;
        if (s is WorkTypesLoaded) {
          emit(WorkTypesLoaded(
            workTypes: s.workTypes
                .map((w) => w.id == workTypeId ? workType : w)
                .toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> deleteWorkType(String workTypeId) async {
    final current = state;
    if (current is WorkTypesLoaded) {
      emit(WorkTypesLoaded(workTypes: current.workTypes, isSaving: true));
    }
    final result = await _deleteWorkTypeUseCase(
      params: DeleteWorkTypeParams(workTypeId: workTypeId),
    );
    result.fold(
      (failure) {
        final s = state;
        if (s is WorkTypesLoaded) {
          emit(WorkTypesLoaded(workTypes: s.workTypes, isSaving: false));
        }
        emit(WorkTypesError(failure.message));
      },
      (_) {
        final s = state;
        if (s is WorkTypesLoaded) {
          emit(WorkTypesLoaded(
            workTypes: s.workTypes.where((w) => w.id != workTypeId).toList(),
            isSaving: false,
          ));
        }
      },
    );
  }

  Future<void> reorderWorkTypes(int oldIndex, int newIndex) async {
    final current = state;
    if (current is! WorkTypesLoaded) return;

    final reordered = List<WorkTypeEntity>.from(current.workTypes);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    emit(WorkTypesLoaded(workTypes: reordered, isSaving: true));

    final orderedIds = reordered.map((w) => w.id).toList();
    final result = await _reorderWorkTypesUseCase(
      params: ReorderWorkTypesParams(orderedIds: orderedIds),
    );
    result.fold(
      (failure) {
        emit(WorkTypesLoaded(workTypes: current.workTypes, isSaving: false));
        emit(WorkTypesError(failure.message));
      },
      (_) {
        emit(WorkTypesLoaded(workTypes: reordered, isSaving: false));
      },
    );
  }
}
