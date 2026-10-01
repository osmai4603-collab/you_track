import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/agile_board.dart';

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
