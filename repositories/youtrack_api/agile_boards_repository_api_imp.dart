import 'package:fpdart/fpdart.dart';
import 'package:youtrack_api/src/api/agile_boards_api.dart';
import 'package:youtrack_api/src/models/board_model.dart';
import 'package:youtrack_api/src/network/network_error.dart';
import 'package:youtrack_frontend/core/enums/issue_priority_type_enum.dart';
import 'package:youtrack_frontend/core/enums/issue_state_enum.dart';
import 'package:youtrack_frontend/core/enums/issue_type_enum.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/agile_boards_repository.dart';
import 'package:youtrack_frontend/features/agile_boards/domain/entities/agile_board.dart';
import 'package:youtrack_frontend/features/agile_boards/domain/entities/board_card.dart';
import 'package:youtrack_frontend/features/agile_boards/domain/entities/board_column.dart';
import 'package:youtrack_frontend/features/agile_boards/domain/entities/board_swimlane.dart';
import 'package:youtrack_frontend/features/issues/domain/entities/sprint.dart';
import 'package:youtrack_frontend/features/projects/domain/entities/subsystem_entity.dart';

class AgileBoardsRepositoryImpl implements AgileBoardsRepository {
  final AgileBoardsApi _api;

  AgileBoardsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, AgileBoard>> getBoardDetails({
    required String projectId,
    String? sprintId,
  }) async {
    final result = await _api.getBoard(projectId, sprintID: sprintId);
    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }
    return Right(_toEntity(result.data));
  }

  AgileBoard _toEntity(AgileBoardModel model) {
    final swimlanes = model.swimlanes.map(_toSwimlane).toList(growable: false);

    return AgileBoard(
      projectId: model.projectId,
      headers: _toHeaders(model, swimlanes),
      columnCounts: _toColumnCounts(model.columnCounts),
      swimlanes: swimlanes,
      sprints: model.sprints
          .map((sprint) => _toSprint(sprint, model.projectId))
          .toList(growable: false),
      activeSprint: model.activeSprint == null
          ? null
          : _toSprint(model.activeSprint!, model.projectId),
    );
  }

  static List<IssueStateEnum> _toHeaders(
    AgileBoardModel model,
    List<BoardSwimlane> swimlanes,
  ) {
    final states = _toStates(model.headers);
    if (states.isNotEmpty) return states;

    final derived = <IssueStateEnum>[];
    for (final swimlane in swimlanes) {
      for (final column in swimlane.columns) {
        if (!derived.contains(column.state)) derived.add(column.state);
      }
    }
    return derived;
  }

  static List<IssueStateEnum> _toStates(List<String> names) {
    final known = IssueStateEnum.values.map((state) => state.name).toSet();
    final states = <IssueStateEnum>[];
    for (final name in names) {
      if (!known.contains(name)) continue;
      final state = IssueStateEnum.of(name);
      if (!states.contains(state)) states.add(state);
    }
    return states;
  }

  static Map<IssueStateEnum, int> _toColumnCounts(Map<String, int> counts) {
    final known = IssueStateEnum.values.map((state) => state.name).toSet();
    final parsed = <IssueStateEnum, int>{};
    for (final entry in counts.entries) {
      if (!known.contains(entry.key)) continue;
      parsed[IssueStateEnum.of(entry.key)] = entry.value;
    }
    return parsed;
  }

  static BoardSwimlane _toSwimlane(BoardSwimlaneModel model) {
    final subsystem = _toSubsystem(model.subsystem);
    return BoardSwimlane(
      subsystem: subsystem,
      columns: model.columns
          .map((column) => _toColumn(column, subsystem))
          .toList(growable: false),
    );
  }

  static SubsystemEntity _toSubsystem(BoardSubsystemModel model) {
    return SubsystemEntity(
      id: model.id,
      name: model.name,
      projectId: model.projectId,
      ownerId: '',
      color: model.color,
      firstLetter: model.firstLetter,
    );
  }

  static BoardColumn _toColumn(
    BoardColumnModel model,
    SubsystemEntity subsystem,
  ) {
    final state = _toState(model.state);
    return BoardColumn(
      state: state,
      name: model.name,
      cards: model.cards
          .map((card) => _toCard(card, state, subsystem))
          .toList(growable: false),
    );
  }

  static BoardCard _toCard(
    BoardCardModel model,
    IssueStateEnum columnState,
    SubsystemEntity subsystem,
  ) {
    final known = IssueStateEnum.values.map((state) => state.name);
    return BoardCard(
      id: model.id,
      issueKey: model.issueKey,
      summary: model.summary,
      state: known.contains(model.state)
          ? IssueStateEnum.of(model.state)
          : columnState,
      priority: _toPriority(model.priority),
      issueType: _toType(model.issueType),
      subsystem: subsystem,
    );
  }

  static Sprint _toSprint(BoardSprintModel model, String projectId) {
    return Sprint(
      id: model.id,
      name: model.name,
      startDate: model.start,
      releaseDate: model.finish,
      isReleased: model.archived,
      description: model.goal,
      projectId: projectId,
    );
  }

  static IssueStateEnum _toState(String name) {
    try {
      return IssueStateEnum.of(name);
    } catch (_) {
      return IssueStateEnum.toDo;
    }
  }

  static IssuePriorityTypeEnum _toPriority(String name) {
    try {
      return IssuePriorityTypeEnum.of(name);
    } catch (_) {
      return IssuePriorityTypeEnum.normal;
    }
  }

  static IssueTypeEnum _toType(String name) {
    try {
      return IssueTypeEnum.of(name);
    } catch (_) {
      return IssueTypeEnum.task;
    }
  }

  @override
  Future<Either<Failure, void>> moveCard({
    required String issueId,
    required IssueStateEnum newState,
  }) async {
    final result = await _api.moveCard(issueId, state: newState.name);
    if (result.isFailure) {
      return Left(_toFailure(result.error));
    }
    return Right(unit);
  }
}

Failure _toFailure(ApiError error) {
  return switch (error) {
    NetworkError() => const NetworkFailure(),
    TimeoutError() => const NetworkFailure(),
    AuthError(:final message) => PermissionDeniedFailure(message),
    PermissionError(:final message) => PermissionDeniedFailure(message),
    ServerError(:final code, :final message) => ServerFailure(
      message.isEmpty ? 'The server returned an error. ($code)' : message,
    ),
    ValidationError(:final message) => ValidationFailure(message),
    ResourceError(:final message) => ValidationFailure(message),
    FeatureError(:final message) => ValidationFailure(message),
    UnknownError(:final error) => ServerFailure(error.toString()),
  };
}
