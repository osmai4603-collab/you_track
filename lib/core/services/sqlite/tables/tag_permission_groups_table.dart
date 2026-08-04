import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class TagPermissionGroupsTable extends TableById implements SqliteTable {
  const TagPermissionGroupsTable();

  @override
  String get tableName => 'tag_permission_groups';

  @override
  String get id => 'id';

  String get tagPermissionId => 'tag_permission_id';
  String get groupId => 'group_id';

  @override
  List<String> get columns => [id, tagPermissionId, groupId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $tagPermissionId TEXT NOT NULL,
      $groupId TEXT NOT NULL
    )
  ''';
}
