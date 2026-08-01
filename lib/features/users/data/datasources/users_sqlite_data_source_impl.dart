import 'dart:convert';
import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/users_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_members_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/groups_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_projects_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/projects_table.dart';
import 'package:issues_tracking/features/users/data/datasources/users_remote_data_source.dart';
import 'package:issues_tracking/features/users/data/models/user_model.dart';

class UsersSqliteDataSourceImpl implements UsersRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final UsersTable _table = const UsersTable();
  final GroupMembersTable _groupMembersTable = const GroupMembersTable();
  final GroupsTable _groupsTable = const GroupsTable();
  final GroupProjectsTable _groupProjectsTable = const GroupProjectsTable();
  final ProjectsTable _projectsTable = const ProjectsTable();

  UsersSqliteDataSourceImpl(this._sqlite);

  Map<String, dynamic> _prepareDataForSqlite(Map<String, dynamic> data) {
    final Map<String, dynamic> prepared = Map.of(data);
    if (prepared.containsKey('groups') && prepared['groups'] != null) {
      prepared['groups'] = jsonEncode(prepared['groups']);
    }
    if (prepared.containsKey('projects') && prepared['projects'] != null) {
      prepared['projects'] = jsonEncode(prepared['projects']);
    }
    if (prepared.containsKey('is_banned') && prepared['is_banned'] is bool) {
      prepared['is_banned'] = prepared['is_banned'] ? 1 : 0;
    }
    return prepared;
  }

  Map<String, dynamic> _parseDataFromSqlite(Map<String, dynamic> data) {
    final Map<String, dynamic> parsed = Map.of(data);
    
    // Attempt to enrich with groups and projects if not already populated
    if (!parsed.containsKey('groups') || !parsed.containsKey('projects')) {
      final userId = parsed['id']?.toString();
      if (userId != null) {
        final groupNames = <String>[];
        final projectNames = <String>{};
        
        final memberRows = _sqlite.query(
          table: _groupMembersTable.tableName,
          where: '${_groupMembersTable.userId} = ?',
          whereArgs: [userId],
        );
        
        for (final mr in memberRows) {
           final groupId = mr['group_id'];
           final gRow = _sqlite.fetchFirst(
             tableName: _groupsTable.tableName,
             where: '${_groupsTable.id} = ?',
             whereArgs: [groupId],
           );
           if (gRow != null) {
             groupNames.add(gRow['name'] as String);
             
             final gpRows = _sqlite.query(
               table: _groupProjectsTable.tableName,
               where: '${_groupProjectsTable.groupId} = ?',
               whereArgs: [groupId],
             );
             for (final gp in gpRows) {
                final projectId = gp['project_id'];
                final pRow = _sqlite.fetchFirst(
                  tableName: _projectsTable.tableName,
                  where: '${_projectsTable.id} = ?',
                  whereArgs: [projectId],
                );
                if (pRow != null) {
                  projectNames.add(pRow['name'] as String);
                }
             }
           }
        }
        
        parsed['groups'] = groupNames;
        parsed['projects'] = projectNames.toList();
      }
    }

    if (parsed.containsKey('groups') && parsed['groups'] is String) {
      try {
        parsed['groups'] = jsonDecode(parsed['groups'] as String);
      } catch (_) {
        parsed['groups'] = [];
      }
    }
    if (parsed.containsKey('projects') && parsed['projects'] is String) {
      try {
        parsed['projects'] = jsonDecode(parsed['projects'] as String);
      } catch (_) {
        parsed['projects'] = [];
      }
    }
    if (parsed.containsKey('is_banned')) {
      parsed['is_banned'] = parsed['is_banned'] == 1;
    }
    return parsed;
  }

  @override
  Future<UserModel> createUser(
    Map<String, dynamic> data, {
    String? password,
  }) async {
    final Map<String, dynamic> json = Map.of(data);
    if (!json.containsKey('id') ||
        json['id'] == null ||
        json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    if (!json.containsKey('created_at') || json['created_at'] == null) {
      json['created_at'] = DateTime.now().toIso8601String();
    }

    final prepared = _prepareDataForSqlite(json);
    _sqlite.insert(table: _table.tableName, data: prepared);

    return getUserById(json['id'].toString());
  }

  @override
  Future<void> deleteUser(String id) async {
    _sqlite.execute('DELETE FROM ${_table.tableName} WHERE ${_table.id} = ?', [
      id,
    ]);
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final row = _sqlite.fetchFirst(
      tableName: _table.tableName,
      where: '${_table.id} = ?',
      whereArgs: [id],
    );
    if (row == null) {
      throw DatabaseException('User not found');
    }
    return UserModel.fromJson(_parseDataFromSqlite(row));
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final rows = _sqlite.query(
      table: _table.tableName,
      orderBy: 'created_at DESC',
    );
    return rows
        .map((row) => UserModel.fromJson(_parseDataFromSqlite(row)))
        .toList();
  }

  @override
  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    final json = Map<String, dynamic>.of(data);
    json.remove('id');
    json['updated_at'] = DateTime.now().toIso8601String();

    final prepared = _prepareDataForSqlite(json);

    final setClause = prepared.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_table.tableName} SET $setClause WHERE ${_table.id} = ?',
      [...prepared.values, id],
    );

    return getUserById(id);
  }
}
