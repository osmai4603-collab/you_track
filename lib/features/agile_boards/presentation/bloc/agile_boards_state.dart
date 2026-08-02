import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/agile_board.dart';

abstract class AgileBoardsState extends Equatable {
  const AgileBoardsState();

  @override
  List<Object?> get props => [];
}

class AgileBoardsInitial extends AgileBoardsState {}

class AgileBoardsLoading extends AgileBoardsState {}

class AgileBoardsLoaded extends AgileBoardsState {
  final AgileBoard board;
  final String? highlightedCardId;

  const AgileBoardsLoaded({
    required this.board,
    this.highlightedCardId,
  });

  AgileBoardsLoaded copyWith({
    AgileBoard? board,
    String? highlightedCardId,
    bool clearHighlightedCard = false,
  }) {
    return AgileBoardsLoaded(
      board: board ?? this.board,
      highlightedCardId: clearHighlightedCard
          ? null
          : (highlightedCardId ?? this.highlightedCardId),
    );
  }

  @override
  List<Object?> get props => [board, highlightedCardId];
}

class AgileBoardsError extends AgileBoardsState {
  final String message;

  const AgileBoardsError({required this.message});

  @override
  List<Object?> get props => [message];
}
