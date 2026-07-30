import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class IssueLinksTable extends TableById implements SqliteTable {
  const IssueLinksTable();

  @override
  String get tableName => 'issue_links';

  @override
  String get id => 'id';

  String get linkType => 'link_type';
  String get sourceIssueId => 'source_issue_id';
  String get targetIssueId => 'target_issue_id';
  String get createdAt => 'created_at';

  @override
  List<String> get columns => [
        id,
        linkType,
        sourceIssueId,
        targetIssueId,
        createdAt,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $linkType TEXT NOT NULL,
      $sourceIssueId TEXT NOT NULL,
      $targetIssueId TEXT NOT NULL,
      $createdAt TEXT NOT NULL
    )
  ''';
}
