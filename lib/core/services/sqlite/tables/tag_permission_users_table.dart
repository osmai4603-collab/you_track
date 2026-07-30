import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class TagPermissionUsersTable extends TableById implements SqliteTable {
  const TagPermissionUsersTable();

  @override
  String get tableName => 'tag_permission_users';

  @override
  String get id => 'id';

  String get tagPermissionId => 'tag_permission_id';
  String get userId => 'user_id';

  @override
  List<String> get columns => [id, tagPermissionId, userId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $tagPermissionId TEXT NOT NULL,
      $userId TEXT NOT NULL
    )
  ''';
}
