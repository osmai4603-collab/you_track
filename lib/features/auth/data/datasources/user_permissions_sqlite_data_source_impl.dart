import 'dart:convert';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_members_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_roles_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/projects_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/roles_table.dart';
import 'package:issues_tracking/features/auth/data/datasources/user_permissions_data_source.dart';
import 'package:issues_tracking/features/auth/data/models/user_permissions_model.dart';
import 'package:issues_tracking/features/auth/data/models/user_role_assignment_model.dart';

class UserPermissionsSqliteDataSourceImpl implements UserPermissionsDataSource {
  final SqliteDatabaseSync _sqlite;
  final GroupMembersTable _groupMembersTable = const GroupMembersTable();
  final GroupRolesTable _groupRolesTable = const GroupRolesTable();
  final RolesTable _rolesTable = const RolesTable();
  final ProjectsTable _projectsTable = const ProjectsTable();

  UserPermissionsSqliteDataSourceImpl(this._sqlite);

  @override
  Future<UserPermissionsModel> getUserPermissions(String userId) async {
    final roleAssignments = <UserRoleAssignmentModel>[];
    final ownedProjectIds = <String>[];

    // 1. Get groups user belongs to
    final groupMembers = _sqlite.query(
      table: _groupMembersTable.tableName,
      where: '${_groupMembersTable.userId} = ?',
      whereArgs: [userId],
    );

    for (final member in groupMembers) {
      final groupId = member[_groupMembersTable.groupId].toString();

      // 2. Get roles for each group
      final groupRoles = _sqlite.query(
        table: _groupRolesTable.tableName,
        where: '${_groupRolesTable.groupId} = ?',
        whereArgs: [groupId],
      );

      for (final groupRole in groupRoles) {
        final roleName = groupRole[_groupRolesTable.roleName].toString();
        final projectId = groupRole[_groupRolesTable.projectId]?.toString();

        // 3. Get permissions for the role
        final role = _sqlite.fetchFirst(
          tableName: _rolesTable.tableName,
          where: '${_rolesTable.name} = ?',
          whereArgs: [roleName],
        );

        if (role != null) {
          final permissionsString = role[_rolesTable.permissions]?.toString();
          List<dynamic> permissionsList = [];
          if (permissionsString != null && permissionsString.isNotEmpty) {
            try {
              permissionsList = jsonDecode(permissionsString) as List<dynamic>;
            } catch (_) {}
          }

          final permissions = <Permission>[];
          for (final entry in permissionsList) {
            try {
              permissions.add(Permission.of(entry.toString()));
            } catch (_) {
              // Skip unknown permission names
            }
          }

          roleAssignments.add(UserRoleAssignmentModel(
            roleName: roleName,
            permissions: permissions,
            projectId: projectId?.isEmpty == true ? null : projectId,
            groupId: groupId,
          ));
        }
      }
    }

    // 4. Get owned projects
    final projects = _sqlite.query(
      table: _projectsTable.tableName,
      where: '${_projectsTable.ownerId} = ?',
      whereArgs: [userId],
    );

    for (final project in projects) {
      final pid = project[_projectsTable.id]?.toString();
      if (pid != null && pid.isNotEmpty) {
        ownedProjectIds.add(pid);
      }
    }

    return UserPermissionsModel(
      roleAssignments: roleAssignments,
      ownedProjectIds: ownedProjectIds,
    );
  }
}
