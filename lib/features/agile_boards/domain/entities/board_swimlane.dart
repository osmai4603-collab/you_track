import 'package:issues_tracking/core/entities/entity.dart';

import 'package:issues_tracking/features/agile_boards/domain/entities/board_column.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';

class BoardSwimlane extends Entity {
  final SubsystemEntity subsystem;
  final List<BoardColumn> columns;

  const BoardSwimlane({required this.subsystem, required this.columns});

  @override
  List<Object?> get props => [subsystem, columns];

  @override
  BoardSwimlane copyWith({SubsystemEntity? subsystem, List<BoardColumn>? columns}) {
    return BoardSwimlane(
      subsystem: subsystem ?? this.subsystem,
      columns: columns ?? this.columns,
    );
  }
}
