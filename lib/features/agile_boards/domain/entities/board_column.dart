import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_card.dart';

class BoardColumn extends Entity {
  final IssueStateEnum state;
  final String name;
  final List<BoardCard> cards;

  const BoardColumn({
    required this.state,
    required this.name,
    this.cards = const [],
  });

  @override
  BoardColumn copyWith({
    IssueStateEnum? state,
    String? name,
    List<BoardCard>? cards,
  }) {
    return BoardColumn(
      state: state ?? this.state,
      name: name ?? this.name,
      cards: cards ?? this.cards,
    );
  }

  @override
  List<Object?> get props => [state, name, cards];
}
