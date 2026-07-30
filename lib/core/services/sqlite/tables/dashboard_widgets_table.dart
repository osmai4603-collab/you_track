import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class DashboardWidgetsTable extends TableById implements SqliteTable {
  const DashboardWidgetsTable();

  @override
  String get tableName => 'dashboard_widgets';

  @override
  String get id => 'id';

  String get dashboardId => 'dashboard_id';
  String get widgetType => 'widget_type';
  String get title => 'title';
  String get config => 'config';
  String get positionX => 'position_x';
  String get positionY => 'position_y';
  String get width => 'width';
  String get height => 'height';
  String get createdAt => 'created_at';
  String get updatedAt => 'updated_at';

  @override
  List<String> get columns => [
        id,
        dashboardId,
        widgetType,
        title,
        config,
        positionX,
        positionY,
        width,
        height,
        createdAt,
        updatedAt,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $dashboardId TEXT NOT NULL,
      $widgetType TEXT NOT NULL,
      $title TEXT NOT NULL,
      $config TEXT,
      $positionX INTEGER DEFAULT 0,
      $positionY INTEGER DEFAULT 0,
      $width INTEGER DEFAULT 1,
      $height INTEGER DEFAULT 1,
      $createdAt TEXT NOT NULL,
      $updatedAt TEXT NOT NULL
    )
  ''';
}
