import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class ProjectTemplatesTable extends TableById implements SqliteTable {
  const ProjectTemplatesTable();

  @override
  String get tableName => 'project_templates';

  @override
  String get id => 'id';

  String get name => 'name';
  String get description => 'description';
  String get iconKey => 'icon_key';
  String get defaultFields => 'default_fields';

  @override
  List<String> get columns => [id, name, description, iconKey, defaultFields];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $description TEXT,
      $iconKey TEXT,
      $defaultFields TEXT
    )
  ''';
}
