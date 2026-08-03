import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';

import 'package:issues_tracking/features/agile_boards/domain/entities/board_card.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_column.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_swimlane.dart';
import 'package:issues_tracking/features/agile_boards/domain/use_cases/get_board_details_use_case.dart';
import 'package:issues_tracking/features/agile_boards/domain/use_cases/move_card_use_case.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_event.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_state.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/stream_issues.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_subsystem_by_id_use_case.dart';

class AgileBoardsBloc extends Bloc<AgileBoardsEvent, AgileBoardsState> {
  final GetBoardDetailsUseCase getBoardDetailsUseCase;
  final MoveCardUseCase moveCardUseCase;
  final StreamIssues streamIssues;
  final GetSubsystemByIdUseCase getSubsystemById;
  StreamSubscription<Issue>? _issueSubscription;

  AgileBoardsBloc({
    required this.getBoardDetailsUseCase,
    required this.moveCardUseCase,
    required this.streamIssues,
    required this.getSubsystemById,
  }) : super(AgileBoardsInitial()) {
    on<LoadBoardDetailsEvent>(_onLoadBoardDetails);
    on<MoveCardEvent>(_onMoveCard);
    on<StartIssueUpdatesEvent>(_onStartIssueUpdates);
    on<IssueUpdatedEvent>(_onIssueUpdated);
    on<ClearHighlightedCardEvent>(_onClearHighlightedCard);
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

  Future<void> _onStartIssueUpdates(
    StartIssueUpdatesEvent event,
    Emitter<AgileBoardsState> emit,
  ) async {
    _issueSubscription?.cancel();
    _issueSubscription = streamIssues(
      params: GetIssuesParams(
        filter: IssueFilter(projectFilter: event.projectId),
      ),
    ).listen(
      (issue) => add(IssueUpdatedEvent(issue)),
      onError: (_) {},
    );
  }

  Future<void> _onIssueUpdated(
    IssueUpdatedEvent event,
    Emitter<AgileBoardsState> emit,
  ) async {
    if (state is! AgileBoardsLoaded) return;

    final currentState = state as AgileBoardsLoaded;
    final board = currentState.board;
    final issue = event.issue;
    final issueId = issue.id;

    bool cardFound = false;
    final List<BoardSwimlane> newSwimlanes = [];
    BoardCard? movedCard;

    for (final swimlane in board.swimlanes) {
      final newColumns = <BoardColumn>[];
      for (final column in swimlane.columns) {
        final cardIndex = column.cards.indexWhere((c) => c.id == issueId);
        if (cardIndex != -1) {
          cardFound = true;
          final currentCard = column.cards[cardIndex];
          var subsystem = currentCard.subsystem;
          if (issue.subsystemId != null) {
            final subsystemResult = await getSubsystemById(
              params: GetSubsystemByIdParams(id: issue.subsystemId!),
            );
            subsystem = subsystemResult.fold(
              (_) => currentCard.subsystem,
              (value) => value,
            );
          }

          final updatedCard = currentCard.copyWith(
            summary: issue.summary,
            state: issue.state,
            priority: issue.priority,
            issueType: issue.issueType,
            subsystem: subsystem,
            assigneeAvatarUrl: issue.assigneeAvatarUrl,
            assigneeName: issue.assigneeName,
            estimation: issue.estimation,
          );

          if (issue.state == column.state) {
            final updatedCards = List<BoardCard>.from(column.cards)
              ..[cardIndex] = updatedCard;
            newColumns.add(column.copyWith(cards: updatedCards));
          } else {
            movedCard = updatedCard;
            final updatedCards = List<BoardCard>.from(column.cards)
              ..removeAt(cardIndex);
            newColumns.add(column.copyWith(cards: updatedCards));
          }
        } else {
          newColumns.add(column);
        }
      }
      newSwimlanes.add(swimlane.copyWith(columns: newColumns));
    }

    if (!cardFound) return;

    if (movedCard != null) {
      for (var i = 0; i < newSwimlanes.length; i++) {
        final swimlane = newSwimlanes[i];
        final targetIndex = swimlane.columns.indexWhere(
          (column) => column.state == issue.state,
        );
        if (targetIndex != -1) {
          final targetColumn = swimlane.columns[targetIndex];
          final updatedCards = List<BoardCard>.from(targetColumn.cards)
            ..add(movedCard);
          final updatedColumns = List<BoardColumn>.from(swimlane.columns)
            ..[targetIndex] = targetColumn.copyWith(cards: updatedCards);
          newSwimlanes[i] = swimlane.copyWith(columns: updatedColumns);
          break;
        }
      }
    }

    final newColumnCounts = <IssueStateEnum, int>{};
    for (final header in board.headers) {
      final count = newSwimlanes.fold<int>(
        0,
        (sum, swimlane) => sum +
            swimlane.columns
                .firstWhere((column) => column.state == header)
                .cards
                .length,
      );
      newColumnCounts[header] = count;
    }

    final newBoard = board.copyWith(
      swimlanes: newSwimlanes,
      columnCounts: newColumnCounts,
    );

    emit(currentState.copyWith(
      board: newBoard,
      highlightedCardId: issueId,
    ));

    Future.delayed(const Duration(seconds: 4), () {
      if (state is AgileBoardsLoaded &&
          (state as AgileBoardsLoaded).highlightedCardId == issueId) {
        add(ClearHighlightedCardEvent());
      }
    });
  }

  Future<void> _onClearHighlightedCard(
    ClearHighlightedCardEvent event,
    Emitter<AgileBoardsState> emit,
  ) async {
    if (state is AgileBoardsLoaded) {
      emit((state as AgileBoardsLoaded).copyWith(
        clearHighlightedCard: true,
      ));
    }
  }

}
