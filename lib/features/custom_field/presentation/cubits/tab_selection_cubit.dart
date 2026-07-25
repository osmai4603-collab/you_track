import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/field_type.dart';

part 'tab_selection_state.dart';

class TabSelectionCubit extends Cubit<TabSelectionState> {
  TabSelectionCubit() : super(TabSelectionState.initial());

  void selectType(FieldType type) {
    emit(state.copyWith(selectedType: type));
  }
}