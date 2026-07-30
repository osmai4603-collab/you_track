import 'dart:convert';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/roles_table.dart';
import 'package:issues_tracking/features/roles/data/datasources/roles_remote_data_source.dart';
import 'package:issues_tracking/features/roles/data/models/role_model.dart';

class RolesSqliteDataSourceImpl implements RolesRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final RolesTable _table = const RolesTable();

  RolesSqliteDataSourceImpl(this._sqlite);

  Map<String, dynamic> _prepareDataForSqlite(Map<String, dynamic> data) {
    final Map<String, dynamic> prepared = Map.of(data);
    if (prepared.containsKey('permissions')) {
      prepared['permissions'] = jsonEncode(prepared['permissions']);
    }
    return prepared;
  }

  Map<String, dynamic> _parseDataFromSqlite(Map<String, dynamic> data) {
    final Map<String, dynamic> parsed = Map.of(data);
    if (parsed.containsKey('permissions') && parsed['permissions'] is String) {
      try {
        parsed['permissions'] = jsonDecode(parsed['permissions'] as String);
      } catch (_) {
        parsed['permissions'] = [];
      }
    }
    return parsed;
  }

  @override
  Future<RoleModel> createRole(Map<String, dynamic> data) async {
    final prepared = _prepareDataForSqlite(data);
    _sqlite.insert(table: _table.tableName, data: prepared);
    
    // SQLite doesn't return the full object on insert, so we fetch it
    final name = data['name'] as String;
    return getRoleByName(name);
  }

  @override
  Future<void> deleteRole(String name) async {
    _sqlite.execute('DELETE FROM ${_table.tableName} WHERE ${_table.name} = ?', [name]);
  }

  @override
  Future<RoleModel> getRoleByName(String name) async {
    final row = _sqlite.fetchFirst(
      tableName: _table.tableName,
      where: '${_table.name} = ?',
      whereArgs: [name],
    );
    if (row == null) {
      throw Exception('Role not found');
    }
    return RoleModel.fromJson(_parseDataFromSqlite(row));
  }

  @override
  Future<List<RoleModel>> getRoles() async {
    final rows = _sqlite.query(table: _table.tableName);
    return rows.map((row) => RoleModel.fromJson(_parseDataFromSqlite(row))).toList();
  }

  @override
  Future<RoleModel> updateRole(String name, Map<String, dynamic> data) async {
    final prepared = _prepareDataForSqlite(data);
    
    final setClause = prepared.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_table.tableName} SET $setClause WHERE ${_table.name} = ?',
      [...prepared.values, name],
    );
    
    return getRoleByName(name);
  }
}
