import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class BuildsTable extends TableById implements SqliteTable {
  const BuildsTable();

  @override
  String get tableName => 'builds';

  @override
  String get id => 'id';

  String get name => 'name';
  String get date => 'date';
  String get projectId => 'project_id';

  @override
  List<String> get columns => [id, name, date, projectId];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $date TEXT,
      $projectId TEXT
    )
  ''';
}
