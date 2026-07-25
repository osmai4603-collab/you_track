import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'privacy_state_state.dart';

class PrivacyStateCubit extends Cubit<PrivacyStateState> {
  PrivacyStateCubit() : super(PrivacyStateState.initial());

  void togglePrivacy() {
    emit(state.copyWith(isPrivate: !state.isPrivate));
  }

  void setPrivacy(bool isPrivate) {
    emit(state.copyWith(isPrivate: isPrivate));
  }
}