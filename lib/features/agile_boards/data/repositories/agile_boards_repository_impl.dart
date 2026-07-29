import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/features/agile_boards/data/datasources/agile_boards_supabase_data_source.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/agile_board.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_column.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_swimlane.dart';
import 'package:issues_tracking/features/agile_boards/domain/repositories/agile_boards_repository.dart';

class AgileBoardsRepositoryImpl implements AgileBoardsRepository {
  final AgileBoardsRemoteDataSource remoteDataSource;

  AgileBoardsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AgileBoard>> getBoardDetails({
    required String projectId,
    String? sprintId,
  }) async {
    try {
      final cards = await remoteDataSource.getBoardCards(
        projectId,
        sprintId: sprintId,
      );
      final sprints = await remoteDataSource.getProjectSprints(projectId);

      final activeSprint = sprints.where((s) => s.id == sprintId).firstOrNull;

      // Define fixed headers
      final headers = [
        IssueStateEnum.toDo,
        IssueStateEnum.inProgress,
        IssueStateEnum.done,
      ];

      // Calculate total counts per state
      final columnCounts = <IssueStateEnum, int>{};
      for (final header in headers) {
        columnCounts[header] = cards.where((c) => c.state == header).length;
      }

      // Group cards by subsystem
      final Map<IssueSubsystemEnum, List<BoardColumn>> swimlaneMap = {};

      // Initialize swimlane map with empty columns for all unique subsystems
      final uniqueSubsystems = cards.map((c) => c.subsystem).toSet().toList();
      if (uniqueSubsystems.isEmpty) {
        // Add at least one default swimlane if board is empty
        uniqueSubsystems.add(IssueSubsystemEnum.noValue);
      }

      for (final subsystem in uniqueSubsystems) {
        final columns = headers.map((state) {
          final columnCards = cards
              .where((c) => c.subsystem == subsystem && c.state == state)
              .toList();

          String name = '';
          switch (state) {
            case IssueStateEnum.toDo:
              name = 'To Do';
              break;
            case IssueStateEnum.inProgress:
              name = 'In Progress';
              break;
            case IssueStateEnum.done:
              name = 'Done';
              break;
            default:
              name = state.name;
          }

          return BoardColumn(state: state, name: name, cards: columnCards);
        }).toList();

        swimlaneMap[subsystem] = columns;
      }

      final swimlanes = swimlaneMap.entries.map((entry) {
        return BoardSwimlane(subsystem: entry.key, columns: entry.value);
      }).toList();

      final board = AgileBoard(
        projectId: projectId,
        headers: headers,
        columnCounts: columnCounts,
        swimlanes: swimlanes,
        sprints: sprints,
        activeSprint: activeSprint,
      );

      return right(board);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> moveCard({
    required String issueId,
    required IssueStateEnum newState,
  }) async {
    try {
      await remoteDataSource.updateCardState(issueId, newState);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
