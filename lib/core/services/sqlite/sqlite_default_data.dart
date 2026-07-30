import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
// ignore: implementation_imports
import 'package:sqlite3/src/ffi/api.dart';

final class DefaultDataInserter {
  final SqliteDatabaseSync _sqlite;
  const DefaultDataInserter(this._sqlite);

  static void insertDefaults(Database db) {}
}
