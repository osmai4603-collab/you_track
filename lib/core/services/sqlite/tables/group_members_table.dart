import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class GroupMembersTable extends TableById implements SqliteTable {
  const GroupMembersTable();

  @override
  String get tableName => 'group_members';

  @override
  String get id => 'id';

  String get userId => 'user_id';
  String get groupId => 'group_id';

  @override
  List<String> get columns => [id, userId, groupId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $userId TEXT NOT NULL,
      $groupId TEXT NOT NULL
    )
  ''';
}
