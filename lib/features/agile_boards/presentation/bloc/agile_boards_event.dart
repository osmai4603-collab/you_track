import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';

abstract class AgileBoardsEvent extends Equatable {
  const AgileBoardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBoardDetailsEvent extends AgileBoardsEvent {
  final String projectId;
  final String? sprintId;

  const LoadBoardDetailsEvent({
    required this.projectId,
    this.sprintId,
  });

  @override
  List<Object?> get props => [projectId, sprintId];
}

class MoveCardEvent extends AgileBoardsEvent {
  final String issueId;
  final IssueStateEnum newState;
  final IssueStateEnum oldState;

  const MoveCardEvent({
    required this.issueId,
    required this.newState,
    required this.oldState,
  });

  @override
  List<Object?> get props => [issueId, newState, oldState];
}
