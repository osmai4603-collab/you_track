part of 'custom_field_panel_cubit.dart';

class CustomFieldPanelState extends Equatable {
  final bool isPanelOpen;

  const CustomFieldPanelState({required this.isPanelOpen});

  factory CustomFieldPanelState.initial() {
    return const CustomFieldPanelState(isPanelOpen: false);
  }

  CustomFieldPanelState copyWith({bool? isPanelOpen}) {
    return CustomFieldPanelState(
      isPanelOpen: isPanelOpen ?? this.isPanelOpen,
    );
  }

  @override
  List<Object?> get props => [isPanelOpen];
}