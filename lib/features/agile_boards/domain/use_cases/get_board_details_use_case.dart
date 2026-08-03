import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/agile_board.dart';
import 'package:issues_tracking/features/agile_boards/domain/repositories/agile_boards_repository.dart';

class GetBoardDetailsUseCase
    extends UseCase<AgileBoard, GetBoardDetailsParams> {
  final AgileBoardsRepository repository;

  GetBoardDetailsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetBoardDetailsParams params) => params.projectId;

  @override
  Future<Either<Failure, AgileBoard>> call({
    required GetBoardDetailsParams params,
  }) async {
    return await repository.getBoardDetails(
      projectId: params.projectId,
      sprintId: params.sprintId,
    );
  }
}

class GetBoardDetailsParams extends Params {
  final String projectId;
  final String? sprintId;

  const GetBoardDetailsParams({required this.projectId, this.sprintId});

  @override
  List<Object?> get props => [projectId, sprintId];
}
