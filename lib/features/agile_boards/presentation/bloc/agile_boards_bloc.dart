import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_column.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_swimlane.dart';
import 'package:issues_tracking/features/agile_boards/domain/use_cases/get_board_details_use_case.dart';
import 'package:issues_tracking/features/agile_boards/domain/use_cases/move_card_use_case.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_event.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_state.dart';

class AgileBoardsBloc extends Bloc<AgileBoardsEvent, AgileBoardsState> {
  final GetBoardDetailsUseCase getBoardDetailsUseCase;
  final MoveCardUseCase moveCardUseCase;

  AgileBoardsBloc({
    required this.getBoardDetailsUseCase,
    required this.moveCardUseCase,
  }) : super(AgileBoardsInitial()) {
    on<LoadBoardDetailsEvent>(_onLoadBoardDetails);
    on<MoveCardEvent>(_onMoveCard);
  }

  Future<void> _onLoadBoardDetails(
    LoadBoardDetailsEvent event,
    Emitter<AgileBoardsState> emit,
  ) async {
    emit(AgileBoardsLoading());
    final result = await getBoardDetailsUseCase(
      params: GetBoardDetailsParams(
        projectId: event.projectId,
        sprintId: event.sprintId,
      ),
    );

    result.fold(
      (failure) => emit(AgileBoardsError(message: failure.message)),
      (board) => emit(AgileBoardsLoaded(board: board)),
    );
  }

  Future<void> _onMoveCard(
    MoveCardEvent event,
    Emitter<AgileBoardsState> emit,
  ) async {
    if (state is! AgileBoardsLoaded) return;

    // Optimistic UI Update
    final currentState = state as AgileBoardsLoaded;
    final board = currentState.board;

    final newSwimlanes = List<BoardSwimlane>.from(board.swimlanes);
    bool cardFound = false;

    for (int i = 0; i < newSwimlanes.length; i++) {
      final swimlane = newSwimlanes[i];
      final newColumns = List<BoardColumn>.from(swimlane.columns);

      final oldColumnIndex = newColumns.indexWhere(
        (c) => c.state == event.oldState,
      );
      if (oldColumnIndex != -1) {
        final oldColumn = newColumns[oldColumnIndex];
        final cardIndex = oldColumn.cards.indexWhere(
          (c) => c.id == event.issueId,
        );

        if (cardIndex != -1) {
          cardFound = true;
          final cardToMove = oldColumn.cards[cardIndex];

          // Remove from old column
          final newOldColumnCards = List.of(oldColumn.cards)
            ..removeAt(cardIndex);
          newColumns[oldColumnIndex] = oldColumn.copyWith(
            cards: newOldColumnCards,
          );

          // Add to new column in the SAME swimlane
          final newColumnIndex = newColumns.indexWhere(
            (c) => c.state == event.newState,
          );
          if (newColumnIndex != -1) {
            final newCol = newColumns[newColumnIndex];
            final newColCards = List.of(newCol.cards)
              ..add(cardToMove.copyWith(state: event.newState));
            newColumns[newColumnIndex] = newCol.copyWith(cards: newColCards);
          }

          newSwimlanes[i] = BoardSwimlane(
            subsystem: swimlane.subsystem,
            columns: newColumns,
          );
          break; // found and moved
        }
      }
    }

    if (!cardFound) return;

    // update columnCounts
    final newColumnCounts = Map<IssueStateEnum, int>.from(board.columnCounts);
    newColumnCounts[event.oldState] =
        (newColumnCounts[event.oldState] ?? 1) - 1;
    newColumnCounts[event.newState] =
        (newColumnCounts[event.newState] ?? 0) + 1;

    final newBoard = board.copyWith(
      swimlanes: newSwimlanes,
      columnCounts: newColumnCounts,
    );
    emit(AgileBoardsLoaded(board: newBoard));

    // Call UseCase
    final result = await moveCardUseCase(
      params: MoveCardParams(issueId: event.issueId, newState: event.newState),
    );

    result.fold(
      (failure) {
        // Rollback on failure
        emit(AgileBoardsError(message: failure.message));
        emit(currentState);
      },
      (_) {
        // Successfully updated on server
      },
    );
  }
}
