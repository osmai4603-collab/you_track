part of 'privacy_state_cubit.dart';

class PrivacyStateState extends Equatable {
  final bool isPrivate;

  const PrivacyStateState({required this.isPrivate});

  factory PrivacyStateState.initial() {
    return const PrivacyStateState(isPrivate: false);
  }

  PrivacyStateState copyWith({bool? isPrivate}) {
    return PrivacyStateState(
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  @override
  List<Object?> get props => [isPrivate];
}