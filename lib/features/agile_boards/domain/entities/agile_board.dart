import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_swimlane.dart';
import 'package:issues_tracking/features/issues/domain/entities/sprint.dart';

class AgileBoard extends Entity {
  final String projectId;
  final List<IssueStateEnum> headers;
  final Map<IssueStateEnum, int> columnCounts;
  final List<BoardSwimlane> swimlanes;
  final List<Sprint> sprints;
  final Sprint? activeSprint;

  const AgileBoard({
    required this.projectId,
    this.headers = const [],
    this.columnCounts = const {},
    this.swimlanes = const [],
    this.sprints = const [],
    this.activeSprint,
  });

  @override
  AgileBoard copyWith({
    String? projectKey,
    List<IssueStateEnum>? headers,
    Map<IssueStateEnum, int>? columnCounts,
    List<BoardSwimlane>? swimlanes,
    List<Sprint>? sprints,
    Sprint? activeSprint,
    bool clearActiveSprint = false,
  }) {
    return AgileBoard(
      projectId: projectKey ?? this.projectId,
      headers: headers ?? this.headers,
      columnCounts: columnCounts ?? this.columnCounts,
      swimlanes: swimlanes ?? this.swimlanes,
      sprints: sprints ?? this.sprints,
      activeSprint: clearActiveSprint
          ? null
          : (activeSprint ?? this.activeSprint),
    );
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
