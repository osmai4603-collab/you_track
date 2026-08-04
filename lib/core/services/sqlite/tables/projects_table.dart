import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class ProjectsTable extends TableById implements SqliteTable {
  const ProjectsTable();

  @override
  String get tableName => 'projects';

  @override
  String get id => 'id';

  String get name => 'name';
  String get projectId => 'project_id';
  String get description => 'description';
  String get isArchived => 'is_archived';
  String get templateType => 'template_type';
  String get ownerId => 'owner_id';
  String get createdAt => 'created_at';
  String get isFavorite => 'is_favorite';
  String get startingNumber => 'starting_number';

  @override
  List<String> get columns => [
        id,
        name,
        projectId,
        description,
        isArchived,
        templateType,
        ownerId,
        createdAt,
        isFavorite,
        startingNumber,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $projectId TEXT NOT NULL,
      $description TEXT,
      $isArchived INTEGER DEFAULT 0,
      $templateType TEXT,
      $ownerId TEXT,
      $createdAt TEXT,
      $isFavorite INTEGER DEFAULT 0,
      $startingNumber INTEGER DEFAULT 1
    )
  ''';
}
