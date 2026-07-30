import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class GroupProjectsTable extends TableById implements SqliteTable {
  const GroupProjectsTable();

  @override
  String get tableName => 'group_projects';

  @override
  String get id => 'id';

  String get groupId => 'group_id';
  String get projectId => 'project_id';

  @override
  List<String> get columns => [id, groupId, projectId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $groupId TEXT NOT NULL,
      $projectId TEXT NOT NULL
    )
  ''';
}
