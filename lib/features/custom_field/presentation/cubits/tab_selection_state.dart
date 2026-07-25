part of 'tab_selection_cubit.dart';

class TabSelectionState extends Equatable {
  final FieldType selectedType;

  const TabSelectionState({required this.selectedType});

  factory TabSelectionState.initial() {
    return const TabSelectionState(selectedType: FieldType.build);
  }

  TabSelectionState copyWith({FieldType? selectedType}) {
    return TabSelectionState(
      selectedType: selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [selectedType];
}