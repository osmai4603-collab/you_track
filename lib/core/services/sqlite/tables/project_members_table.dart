import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class ProjectMembersTable extends TableById implements SqliteTable {
  const ProjectMembersTable();

  @override
  String get tableName => 'project_members';

  @override
  String get id => 'id';

  String get projectId => 'project_id';
  String get userId => 'user_id';
  String get isOwner => 'is_owner';

  @override
  List<String> get columns => [id, projectId, userId, isOwner];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $projectId TEXT NOT NULL,
      $userId TEXT NOT NULL,
      $isOwner INTEGER DEFAULT 0
    )
  ''';
}
