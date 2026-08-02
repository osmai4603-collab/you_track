import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_column.dart';

class BoardSwimlane extends Entity {
  final IssueSubsystemEnum subsystem;
  final List<BoardColumn> columns;

  const BoardSwimlane({required this.subsystem, required this.columns});

  @override
  List<Object?> get props => [subsystem, columns];

  @override
  BoardSwimlane copyWith({IssueSubsystemEnum? subsystem, List<BoardColumn>? columns}) {
    return BoardSwimlane(
      subsystem: subsystem ?? this.subsystem,
      columns: columns ?? this.columns,
    );
  }
}
