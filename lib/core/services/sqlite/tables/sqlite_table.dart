import 'package:issues_tracking/core/services/sqlite/table_info.dart';

abstract class SqliteTable extends TableInfo {
  const SqliteTable();

  String get queryCreateTable;
}
