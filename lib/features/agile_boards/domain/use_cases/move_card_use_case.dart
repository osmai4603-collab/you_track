import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/agile_boards/domain/repositories/agile_boards_repository.dart';

class MoveCardUseCase extends UseCase<void, MoveCardParams> {
  final AgileBoardsRepository repository;

  MoveCardUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.updateIssue;

  @override
  String? getProjectId(MoveCardParams params) => params.projectId;

  @override
  Future<Either<Failure, void>> call({required MoveCardParams params}) async {
    return await repository.moveCard(
      issueId: params.issueId,
      newState: params.newState,
    );
  }
}

class MoveCardParams extends Params {
  final String issueId;
  final IssueStateEnum newState;
  final String? projectId;

  const MoveCardParams({
    required this.issueId,
    required this.newState,
    this.projectId,
  });

  @override
  List<Object?> get props => [issueId, newState, projectId];
}
