import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class CustomFieldValuesTable extends TableById implements SqliteTable {
  const CustomFieldValuesTable();

  @override
  String get tableName => 'custom_field_values';

  @override
  String get id => 'id';

  String get issueId => 'issue_id';
  String get customFieldId => 'custom_field_id';
  String get value => 'value';

  @override
  List<String> get columns => [id, issueId, customFieldId, value];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $issueId TEXT NOT NULL,
      $customFieldId TEXT NOT NULL,
      $value TEXT NOT NULL
    )
  ''';
}
