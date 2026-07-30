import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class TagPermissionsTable extends TableById implements SqliteTable {
  const TagPermissionsTable();

  @override
  String get tableName => 'tag_permissions';

  @override
  String get id => 'id';

  String get tagId => 'tag_id';
  String get permissionType => 'permission_type';
  String get scope => 'scope';

  @override
  List<String> get columns => [id, tagId, permissionType, scope];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $tagId TEXT NOT NULL,
      $permissionType TEXT NOT NULL,
      $scope TEXT NOT NULL
    )
  ''';
}
