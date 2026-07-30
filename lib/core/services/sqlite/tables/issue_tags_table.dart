import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class IssueTagsTable extends TableById implements SqliteTable {
  const IssueTagsTable();

  @override
  String get tableName => 'issue_tags';

  @override
  String get id => 'id';

  String get issueId => 'issue_id';
  String get tagId => 'tag_id';

  @override
  List<String> get columns => [id, issueId, tagId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $issueId TEXT NOT NULL,
      $tagId TEXT NOT NULL
    )
  ''';
}
