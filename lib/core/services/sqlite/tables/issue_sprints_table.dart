import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class IssueSprintsTable extends TableById implements SqliteTable {
  const IssueSprintsTable();

  @override
  String get tableName => 'issue_sprints';

  @override
  String get id => 'id';

  String get issueId => 'issue_id';
  String get sprintId => 'sprint_id';

  @override
  List<String> get columns => [id, issueId, sprintId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $issueId TEXT NOT NULL,
      $sprintId TEXT NOT NULL
    )
  ''';
}
