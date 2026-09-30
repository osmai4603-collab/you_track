import 'package:equatable/equatable.dart';
import 'package:youtrack_api/src/models/json_pick.dart';

/// The composed Kanban view returned by `GET /projects/{projectID}/board`.
///
/// The server builds this as a projection rather than reading a board table:
/// columns are the three issue states, swimlanes are the project's subsystems,
/// and cards are the project's issues bucketed by (subsystem, state). The
/// endpoint takes an optional `sprintID`, which narrows the cards to one
/// sprint.
///
/// [headers], [state], [priority] and [issueType] are kept as Strings rather
/// than enums because the enums live in the app layer, which this package
/// cannot import. The app maps them when it builds the domain entity — and
/// because two of the three app enums throw on an unrecognised value, that
/// mapping is where a malformed row is contained rather than here.
class AgileBoardModel extends Equatable {
  final String projectId;

  /// The column order, one of `to-do`, `in-progress`, `done`. The app renders
  /// its columns in exactly this order.
  final List<String> headers;

  /// How many cards sit in each column, across every swimlane.
  final Map<String, int> columnCounts;

  final List<BoardSwimlaneModel> swimlanes;
  final List<BoardSprintModel> sprints;
  final BoardSprintModel? activeSprint;

  const AgileBoardModel({
    required this.projectId,
    this.headers = const [],
    this.columnCounts = const {},
    this.swimlanes = const [],
    this.sprints = const [],
    this.activeSprint,
  });

  factory AgileBoardModel.fromJson(Map<String, dynamic> data) {
    return AgileBoardModel(
      projectId: pickString(data, const ['projectId', 'project_id']),
      headers: pickStringList(data, const ['headers']),
      columnCounts: pickCountMap(data, const ['columnCounts', 'column_counts']),
      swimlanes: pickList(
        data,
        const ['swimlanes'],
        BoardSwimlaneModel.fromJson,
      ),
      sprints: pickList(data, const ['sprints'], BoardSprintModel.fromJson),
      activeSprint: _sprint(data['activeSprint']),
    );
  }

  static BoardSprintModel? _sprint(Object? value) {
    if (value is! Map) return null;
    return BoardSprintModel.fromJson(Map<String, dynamic>.from(value));
  }

  @override
  List<Object?> get props => [
    projectId,
    headers,
    columnCounts,
    swimlanes,
    sprints,
    activeSprint,
  ];
}

/// One horizontal lane, keyed by the subsystem the card belongs to.
///
/// The server synthesises a single `default`/`General` lane when no issue in the
/// project carries a `subsystem_id`, so a project is never empty.
class BoardSwimlaneModel extends Equatable {
  final BoardSubsystemModel subsystem;
  final List<BoardColumnModel> columns;

  const BoardSwimlaneModel({
    required this.subsystem,
    this.columns = const [],
  });

  factory BoardSwimlaneModel.fromJson(Map<String, dynamic> data) {
    return BoardSwimlaneModel(
      subsystem: BoardSubsystemModel.fromJson(
        pickObject(data, const ['subsystem']) ?? const {},
      ),
      columns: pickList(data, const ['columns'], BoardColumnModel.fromJson),
    );
  }

  @override
  List<Object?> get props => [subsystem, columns];
}

/// The subsystem a swimlane is built from, read from `project_subsystems`.
///
/// The server does not send `ownerId`; the app's own entity declares that field
/// non-nullable, so it maps the absence to ''.
class BoardSubsystemModel extends Equatable {
  final String id;
  final String name;
  final String projectId;

  /// ARGB, as an integer, matching the app's colour fields.
  final int color;
  final String firstLetter;

  const BoardSubsystemModel({
    required this.id,
    required this.name,
    required this.projectId,
    this.color = 0,
    this.firstLetter = '',
  });

  factory BoardSubsystemModel.fromJson(Map<String, dynamic> data) {
    return BoardSubsystemModel(
      id: pickString(data, const ['id']),
      name: pickString(data, const ['name']),
      projectId: pickString(data, const ['projectId', 'project_id']),
      color: pickInt(data, const ['color']),
      firstLetter: pickString(data, const ['firstLetter', 'first_letter']),
    );
  }

  @override
  List<Object?> get props => [id, name, projectId, color, firstLetter];
}

/// One column: a single issue state and the cards in it.
class BoardColumnModel extends Equatable {
  /// One of `to-do`, `in-progress`, `done`.
  final String state;

  final String name;
  final List<BoardCardModel> cards;

  const BoardColumnModel({
    required this.state,
    required this.name,
    this.cards = const [],
  });

  factory BoardColumnModel.fromJson(Map<String, dynamic> data) {
    return BoardColumnModel(
      state: pickString(data, const ['state']),
      name: pickString(data, const ['name']),
      cards: pickList(data, const ['cards'], BoardCardModel.fromJson),
    );
  }

  @override
  List<Object?> get props => [state, name, cards];
}

/// A card on the board.
///
/// Deliberately a projection of the issue row and not the full issue: the board
/// only needs the fields it draws. In particular there is no `subsystem` here —
/// the swimlane already carries it, and the app reads the card's subsystem from
/// the lane that holds it.
///
/// Note the casing: the issue routes are snake_case, but the board route is
/// camelCase throughout (`issueKey`, not `issue_key`). Both spellings are
/// accepted so the parser does not silently yield blank cards if the server
/// later aligns the two.
class BoardCardModel extends Equatable {
  final String id;

  /// The human-readable key, e.g. `DEMO-1`.
  final String issueKey;

  final String summary;

  /// One of `to-do`, `in-progress`, `done`.
  final String state;

  /// One of `show-stopper`, `critical`, `major`, `normal`, `minor`.
  final String priority;

  /// One of `bug`, `cosmetic`, `exception`, `feature`, `task`,
  /// `usability-problem`, `performance-problem`, `epic`.
  final String issueType;

  const BoardCardModel({
    required this.id,
    required this.issueKey,
    required this.summary,
    this.state = 'to-do',
    this.priority = 'normal',
    this.issueType = 'task',
  });

  factory BoardCardModel.fromJson(Map<String, dynamic> data) {
    return BoardCardModel(
      id: pickString(data, const ['id']),
      issueKey: pickString(data, const ['issueKey', 'issue_key']),
      summary: pickString(data, const ['summary']),
      state: pickString(data, const ['state']),
      priority: pickString(data, const ['priority']),
      issueType: pickString(data, const ['issueType', 'issue_type']),
    );
  }

  @override
  List<Object?> get props => [id, issueKey, summary, state, priority, issueType];
}

/// A sprint as the board lists it, from the `sprints` table.
///
/// The board's sprint shape does not match the app's `Sprint` entity field for
/// field: the server sends `start`/`finish` as epoch milliseconds and names the
/// goal `goal`, where the entity wants `startDate`/`releaseDate`/`description`,
/// and it treats `archived` as the release flag. [agileId] and [isStarted] have
/// no counterpart in the entity and are dropped by the app's mapping.
class BoardSprintModel extends Equatable {
  final String id;
  final String name;
  final String agileId;

  final DateTime? start;
  final DateTime? finish;

  final String goal;
  final bool archived;
  final bool isStarted;

  const BoardSprintModel({
    required this.id,
    required this.name,
    this.agileId = '',
    this.start,
    this.finish,
    this.goal = '',
    this.archived = false,
    this.isStarted = false,
  });

  factory BoardSprintModel.fromJson(Map<String, dynamic> data) {
    return BoardSprintModel(
      id: pickString(data, const ['id']),
      name: pickString(data, const ['name']),
      agileId: pickString(data, const ['agileId', 'agile_id']),
      start: pickDate(data, const ['start']),
      finish: pickDate(data, const ['finish']),
      goal: pickString(data, const ['goal']),
      archived: pickBool(data, const ['archived']),
      isStarted: pickBool(data, const ['isStarted', 'is_started']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    agileId,
    start,
    finish,
    goal,
    archived,
    isStarted,
  ];
}
