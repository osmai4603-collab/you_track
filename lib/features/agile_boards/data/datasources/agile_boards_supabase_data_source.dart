import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/features/agile_boards/data/models/board_card_model.dart';
import 'package:issues_tracking/features/issues/data/models/sprint_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AgileBoardsRemoteDataSource {
  Future<List<BoardCardModel>> getBoardCards(String projectId, {String? sprintId});
  Future<List<SprintModel>> getProjectSprints(String projectId);
  Future<void> updateCardState(String issueId, IssueStateEnum newState);
}

class AgileBoardsSupabaseDataSource implements AgileBoardsRemoteDataSource {
  final SupabaseClient supabase;

  AgileBoardsSupabaseDataSource(this.supabase);

  @override
  Future<List<BoardCardModel>> getBoardCards(String projectId, {String? sprintId}) async {
    var query = supabase
        .from('issues')
        .select('*, sprints(*)')
        .eq('project_id', projectId);

    final response = await query;
    final List<BoardCardModel> cards = [];

    for (var row in (response as List)) {
      if (sprintId != null) {
        final sprints = row['sprints'] as List?;
        final bool hasSprint = sprints?.any((s) => s['id'] == sprintId) ?? false;
        if (!hasSprint) continue;
      }
      cards.add(BoardCardModel.fromJson(row));
    }
    return cards;
  }

  @override
  Future<List<SprintModel>> getProjectSprints(String projectId) async {
    final response = await supabase
        .from('sprints')
        .select('*')
        .eq('project_id', projectId);
    return (response as List).map((e) => SprintModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateCardState(String issueId, IssueStateEnum newState) async {
    await supabase
        .from('issues')
        .update({'state': newState.name})
        .eq('id', issueId);
  }
}
