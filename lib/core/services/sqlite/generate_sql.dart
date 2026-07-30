import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.openInMemory();

  final tables = [];

  for (var table in tables) {
    try {
      db.execute(table.queryCreateTable);
    } catch (e) {
      print('Error creating table: \${e}');
    }
  }

  try {} catch (e) {
    print('Error creating triggers: \${e}');
  }

  var sql = StringBuffer();
  final ResultSet resultSet = db.select(
    "SELECT sql FROM sqlite_master WHERE sql IS NOT NULL;",
  );
  for (final row in resultSet) {
    sql.writeln(row['sql']);
    sql.writeln(';');
  }

  db.dispose();

  File('/tmp/extracted_schema.sql').writeAsStringSync(sql.toString());
  print('Schema extracted successfully.');
}
