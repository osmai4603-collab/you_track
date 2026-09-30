import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/core/enums/issue_state_enum.dart';
import 'package:youtrack_frontend/features/agile_boards/domain/entities/agile_board.dart';

abstract class AgileBoardsRepository {
  /// جلب تفاصيل اللوحة (Kanban) لمشروع معين والـ Sprint المحدد إذا وجد
  Future<Either<Failure, AgileBoard>> getBoardDetails({
    required String projectId,
    String? sprintId,
  });

  /// نقل بطاقة بين الأعمدة (تحديث حالة المهمة)
  Future<Either<Failure, void>> moveCard({
    required String issueId,
    required IssueStateEnum newState,
  });
}
