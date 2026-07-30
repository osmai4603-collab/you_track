import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class DashboardsTable extends TableById implements SqliteTable {
  const DashboardsTable();

  @override
  String get tableName => 'dashboards';

  @override
  String get id => 'id';

  String get name => 'name';
  String get ownerId => 'owner_id';
  String get isDefault => 'is_default';
  String get isFavorite => 'is_favorite';
  String get layoutConfig => 'layout_config';
  String get createdAt => 'created_at';
  String get updatedAt => 'updated_at';

  @override
  List<String> get columns => [
        id,
        name,
        ownerId,
        isDefault,
        isFavorite,
        layoutConfig,
        createdAt,
        updatedAt,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $ownerId TEXT NOT NULL,
      $isDefault INTEGER DEFAULT 0,
      $isFavorite INTEGER DEFAULT 0,
      $layoutConfig TEXT,
      $createdAt TEXT NOT NULL,
      $updatedAt TEXT NOT NULL
    )
  ''';
}
