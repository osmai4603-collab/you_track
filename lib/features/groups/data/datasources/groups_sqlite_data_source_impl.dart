import 'dart:convert';
import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_members_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_projects_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_roles_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/groups_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/projects_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/users_table.dart';
import 'package:issues_tracking/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:issues_tracking/features/groups/data/models/group_member_model.dart';
import 'package:issues_tracking/features/groups/data/models/group_model.dart';
import 'package:issues_tracking/features/groups/data/models/group_project_model.dart';
import 'package:issues_tracking/features/groups/data/models/group_role_assignment_model.dart';

class GroupsSqliteDataSourceImpl implements GroupsRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final GroupsTable _groupsTable = const GroupsTable();
  final GroupRolesTable _rolesTable = const GroupRolesTable();
  final GroupMembersTable _membersTable = const GroupMembersTable();
  final GroupProjectsTable _projectsTable = const GroupProjectsTable();
  final UsersTable _usersTable = const UsersTable();
  final ProjectsTable _projectsDataTable = const ProjectsTable();

  List<Map<String, dynamic>> _queryMembersWithUsers(String groupId) {
    final memberRows = _sqlite.query(
      table: _membersTable.tableName,
      where: '${_membersTable.groupId} = ?',
      whereArgs: [groupId],
    );
    for (final member in memberRows) {
      final userRow = _sqlite.fetchFirst(
        tableName: _usersTable.tableName,
        where: '${_usersTable.id} = ?',
        whereArgs: [member['user_id'].toString()],
      );
      member['users'] = userRow;
    }
    return memberRows;
  }

  List<Map<String, dynamic>> _queryRolesWithProjects(String groupId) {
    final roleRows = _sqlite.query(
      table: _rolesTable.tableName,
      where: '${_rolesTable.groupId} = ?',
      whereArgs: [groupId],
    );
    for (final role in roleRows) {
      final projectId = role['project_id']?.toString();
      if (projectId != null && projectId.isNotEmpty) {
      final projectRow = _sqlite.fetchFirst(
        tableName: _projectsDataTable.tableName,
        where: '${_projectsDataTable.id} = ?',
        whereArgs: [projectId],
      );
        role['projects'] = projectRow;
      }
    }
    return roleRows;
  }

  List<Map<String, dynamic>> _queryProjectsWithData(String groupId) {
    final projRows = _sqlite.query(
      table: _projectsTable.tableName,
      where: '${_projectsTable.groupId} = ?',
      whereArgs: [groupId],
    );
    for (final proj in projRows) {
      final pid = proj['project_id']?.toString();
      if (pid != null && pid.isNotEmpty) {
        final projectRow = _sqlite.fetchFirst(
          tableName: _projectsDataTable.tableName,
          where: '${_projectsDataTable.id} = ?',
          whereArgs: [pid],
        );
        proj['projects'] = projectRow;
      }
    }
    return projRows;
  }

  GroupsSqliteDataSourceImpl(this._sqlite);

  @override
  Future<List<GroupMemberModel>> addGroupMembers(
    String groupId,
    List<String> userIds,
  ) async {
    final List<GroupMemberModel> addedMembers = [];

    _sqlite.transaction(() {
      for (final uid in userIds) {
        final id =
            DateTime.now().millisecondsSinceEpoch.toString() +
            uid; // Unique mock ID
        final data = {
          _membersTable.id: id,
          _membersTable.groupId: groupId,
          _membersTable.userId: uid,
        };
        _sqlite.insert(table: _membersTable.tableName, data: data);
        addedMembers.add(GroupMemberModel.fromJson(data));
      }
    });

    return addedMembers;
  }

  @override
  Future<GroupRoleAssignmentModel> assignRole(
    GroupRoleAssignmentModel data,
  ) async {
    final json = data.toJson();
    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    _sqlite.insert(table: _rolesTable.tableName, data: json);
    return data;
  }

  @override
  Future<GroupModel> createGroup(GroupModel data) async {
    final json = data.toJson();
    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // Prepare arrays for SQLite
    if (json['auto_join_domains'] != null) {
      json['auto_join_domains'] = jsonEncode(json['auto_join_domains']);
    }
    if (json['visible_to'] != null) {
      json['visible_to'] = jsonEncode(json['visible_to']);
    }

    _sqlite.insert(table: _groupsTable.tableName, data: json);
    return getGroupById(json['id'].toString());
  }

  @override
  Future<void> deleteGroup(String id) async {
    _sqlite.execute(
      'DELETE FROM ${_groupsTable.tableName} WHERE ${_groupsTable.id} = ?',
      [id],
    );
    _sqlite.execute(
      'DELETE FROM ${_rolesTable.tableName} WHERE ${_rolesTable.groupId} = ?',
      [id],
    );
    _sqlite.execute(
      'DELETE FROM ${_membersTable.tableName} WHERE ${_membersTable.groupId} = ?',
      [id],
    );
    _sqlite.execute(
      'DELETE FROM ${_projectsTable.tableName} WHERE ${_projectsTable.groupId} = ?',
      [id],
    );
  }

  @override
  Future<GroupModel> getGroupById(String id) async {
    final row = _sqlite.fetchFirst(
      tableName: _groupsTable.tableName,
      where: '${_groupsTable.id} = ?',
      whereArgs: [id],
    );
    if (row == null) {
      throw DatabaseException('Group not found');
    }
    row['group_members'] = _queryMembersWithUsers(id);
    row['group_roles'] = _queryRolesWithProjects(id);
    row['group_projects'] = _queryProjectsWithData(id);
    return GroupModel.fromJson(row);
  }

  @override
  Future<List<GroupProjectModel>> addGroupProjects(
    String groupId,
    List<String> projectIds,
  ) async {
    final List<GroupProjectModel> addedProjects = [];

    _sqlite.transaction(() {
      for (final pid in projectIds) {
        final id =
            DateTime.now().millisecondsSinceEpoch.toString() + pid;
        final data = {
          _projectsTable.id: id,
          _projectsTable.groupId: groupId,
          _projectsTable.projectId: pid,
        };
        _sqlite.insert(table: _projectsTable.tableName, data: data);
        addedProjects.add(GroupProjectModel.fromJson(data));
      }
    });

    return addedProjects;
  }

  @override
  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    final rows = _sqlite.query(
      table: _membersTable.tableName,
      where: '${_membersTable.groupId} = ?',
      whereArgs: [groupId],
    );
    return rows.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupRoleAssignmentModel>> getGroupRoles(String groupId) async {
    final rows = _sqlite.query(
      table: _rolesTable.tableName,
      where: '${_rolesTable.groupId} = ?',
      whereArgs: [groupId],
    );
    return rows.map((e) => GroupRoleAssignmentModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupModel>> getGroups() async {
    final rows = _sqlite.query(
      table: _groupsTable.tableName,
      orderBy: 'created_at DESC',
    );
    for (final row in rows) {
      row['group_members'] = _queryMembersWithUsers(row['id'].toString());
      row['group_roles'] = _queryRolesWithProjects(row['id'].toString());
      row['group_projects'] = _queryProjectsWithData(row['id'].toString());
    }
    return rows.map((e) => GroupModel.fromJson(e)).toList();
  }

  @override
  Future<GroupModel> updateGroup(String id, GroupModel data) async {
    final json = data.toJson();
    json['updated_at'] = DateTime.now().toIso8601String();

    // Prepare arrays for SQLite
    if (json['auto_join_domains'] != null) {
      json['auto_join_domains'] = jsonEncode(json['auto_join_domains']);
    }
    if (json['visible_to'] != null) {
      json['visible_to'] = jsonEncode(json['visible_to']);
    }

    final setClause = json.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_groupsTable.tableName} SET $setClause WHERE ${_groupsTable.id} = ?',
      [...json.values, id],
    );

    return getGroupById(id);
  }
}
