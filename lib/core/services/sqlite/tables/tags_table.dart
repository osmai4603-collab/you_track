import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class TagsTable extends TableById implements SqliteTable {
  const TagsTable();

  @override
  String get tableName => 'tags';

  @override
  String get id => 'id';

  String get name => 'name';
  String get ownerId => 'owner_id';
  String get projectId => 'project_id';
  String get shared => 'shared';
  String get removeOnResolution => 'remove_on_resolution';
  String get favorite => 'favorite';
  String get createdAt => 'created_at';
  String get createdBy => 'created_by';

  @override
  List<String> get columns => [
        id,
        name,
        ownerId,
        projectId,
        shared,
        removeOnResolution,
        favorite,
        createdAt,
        createdBy,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $ownerId TEXT NOT NULL,
      $projectId TEXT NOT NULL,
      $shared INTEGER DEFAULT 1,
      $removeOnResolution INTEGER DEFAULT 1,
      $favorite INTEGER DEFAULT 0,
      $createdAt TEXT NOT NULL,
      $createdBy TEXT NOT NULL
    )
  ''';
}
