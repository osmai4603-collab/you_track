import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class TagSubscriptionsTable extends TableById implements SqliteTable {
  const TagSubscriptionsTable();

  @override
  String get tableName => 'tag_subscriptions';

  @override
  String get id => 'id';

  String get tagId => 'tag_id';
  String get eventType => 'event_type';

  @override
  List<String> get columns => [id, tagId, eventType];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $tagId TEXT NOT NULL,
      $eventType TEXT NOT NULL
    )
  ''';
}
