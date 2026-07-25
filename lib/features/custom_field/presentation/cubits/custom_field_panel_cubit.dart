import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'custom_field_panel_state.dart';

class CustomFieldPanelCubit extends Cubit<CustomFieldPanelState> {
  CustomFieldPanelCubit() : super(CustomFieldPanelState.initial());

  void openPanel() {
    emit(state.copyWith(isPanelOpen: true));
  }

  void closePanel() {
    emit(state.copyWith(isPanelOpen: false));
  }

  void togglePanel() {
    if (state.isPanelOpen) {
      closePanel();
    } else {
      openPanel();
    }
  }
}