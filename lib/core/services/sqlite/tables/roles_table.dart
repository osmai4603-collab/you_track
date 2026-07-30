import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class RolesTable extends TableById implements SqliteTable {
  const RolesTable();

  @override
  String get tableName => 'roles';

  @override
  String get id => 'name';

  String get name => 'name';
  String get description => 'description';
  String get permissions => 'permissions';

  @override
  List<String> get columns => [name, description, permissions];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $name TEXT PRIMARY KEY NOT NULL,
      $description TEXT,
      $permissions TEXT
    )
  ''';
}
