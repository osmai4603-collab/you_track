import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class SprintsTable extends TableById implements SqliteTable {
  const SprintsTable();

  @override
  String get tableName => 'sprints';

  @override
  String get id => 'id';

  String get name => 'name';
  String get startDate => 'start_date';
  String get releaseDate => 'release_date';
  String get isReleased => 'is_released';
  String get description => 'description';
  String get color => 'color';
  String get projectId => 'project_id';

  @override
  List<String> get columns => [
        id,
        name,
        startDate,
        releaseDate,
        isReleased,
        description,
        color,
        projectId,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $startDate TEXT,
      $releaseDate TEXT,
      $isReleased INTEGER DEFAULT 0,
      $description TEXT,
      $color INTEGER DEFAULT 0,
      $projectId TEXT
    )
  ''';
}
