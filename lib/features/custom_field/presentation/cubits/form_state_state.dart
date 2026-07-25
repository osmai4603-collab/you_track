part of 'form_state_cubit.dart';

class FormStateState extends Equatable {
  final String fieldName;
  final String description;
  final FieldType type;
  final bool isPrivate;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? error;

  const FormStateState({
    required this.fieldName,
    required this.description,
    required this.type,
    required this.isPrivate,
    required this.isSubmitting,
    required this.isSubmitted,
    this.error,
  });

  factory FormStateState.initial() {
    return FormStateState(
      fieldName: '',
      description: '',
      type: FieldType.build,
      isPrivate: false,
      isSubmitting: false,
      isSubmitted: false,
    );
  }

  FormStateState copyWith({
    String? fieldName,
    String? description,
    FieldType? type,
    bool? isPrivate,
    bool? isSubmitting,
    bool? isSubmitted,
    String? error,
  }) {
    return FormStateState(
      fieldName: fieldName ?? this.fieldName,
      description: description ?? this.description,
      type: type ?? this.type,
      isPrivate: isPrivate ?? this.isPrivate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        fieldName,
        description,
        type,
        isPrivate,
        isSubmitting,
        isSubmitted,
        error,
      ];
}