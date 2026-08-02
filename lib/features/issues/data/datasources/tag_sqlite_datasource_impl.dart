import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_tags_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_permission_users_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_permissions_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_subscriptions_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tags_table.dart';
import 'package:issues_tracking/features/issues/data/datasources/tag_remote_datasource.dart';
import 'package:issues_tracking/features/issues/data/models/tag_model.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

class TagSqliteDatasourceImpl implements TagRemoteDatasource {
  final SqliteDatabaseSync _sqlite;
  final TagsTable _tagsTable = const TagsTable();
  final TagPermissionsTable _permissionsTable = const TagPermissionsTable();
  final TagPermissionUsersTable _permissionUsersTable =
      const TagPermissionUsersTable();
  final TagSubscriptionsTable _subscriptionsTable =
      const TagSubscriptionsTable();
  final IssueTagsTable _issueTagsTable = const IssueTagsTable();

  TagSqliteDatasourceImpl(this._sqlite);

  @override
  Future<void> associateTagWithIssue({
    required String issueId,
    required String tagId,
  }) async {
    _sqlite.insert(
      table: _issueTagsTable.tableName,
      data: {'issue_id': issueId, 'tag_id': tagId},
    );
  }

  @override
  Future<TagModel> createTag({
    required String name,
    required String projectId,
    required String ownerId,
    required bool shared,
    required bool removeOnResolution,
    required bool favorite,
    required Map<String, String> permissions,
    List<String>? specificUserIds,
    required List<String> subscriptionEvents,
  }) async {
    final tagId = DateTime.now().millisecondsSinceEpoch.toString();
    final userSession = get_it<UserSession>();
    final createdBy = userSession.currentUser?.id ?? ownerId;

    _sqlite.insert(
      table: _tagsTable.tableName,
      data: {
        _tagsTable.id: tagId,
        _tagsTable.name: name,
        _tagsTable.projectId: projectId,
        _tagsTable.ownerId: ownerId,
        _tagsTable.shared: shared ? 1 : 0,
        _tagsTable.removeOnResolution: removeOnResolution ? 1 : 0,
        _tagsTable.favorite: favorite ? 1 : 0,
        _tagsTable.createdAt: DateTime.now().toIso8601String(),
        _tagsTable.createdBy: createdBy,
      },
    );

    final List<Map<String, dynamic>> tagPermissionsList = [];
    final List<Map<String, dynamic>> tagSubscriptionsList = [];

    // Permissions
    for (final entry in permissions.entries) {
      final permId =
          DateTime.now().millisecondsSinceEpoch.toString() + entry.key;
      final Map<String, dynamic> permData = {
        _permissionsTable.id: permId,
        _permissionsTable.tagId: tagId,
        _permissionsTable.permissionType: entry.key,
        _permissionsTable.scope: entry.value,
      };
      _sqlite.insert(table: _permissionsTable.tableName, data: permData);

      final List<Map<String, dynamic>> permUsers = [];
      if (entry.value == 'specific_users' && specificUserIds != null) {
        for (final uid in specificUserIds) {
          _sqlite.insert(
            table: _permissionUsersTable.tableName,
            data: {'tag_permission_id': permId, 'user_id': uid},
          );
          permUsers.add({'user_id': uid});
        }
      }

      permData['tag_permission_users'] = permUsers;
      tagPermissionsList.add(permData);
    }

    // Subscriptions
    for (final event in subscriptionEvents) {
      final subId = DateTime.now().millisecondsSinceEpoch.toString() + event;
      final subData = {
        _subscriptionsTable.id: subId,
        _subscriptionsTable.tagId: tagId,
        _subscriptionsTable.eventType: event,
      };
      _sqlite.insert(table: _subscriptionsTable.tableName, data: subData);
      tagSubscriptionsList.add(subData);
    }

    final tagRow = _sqlite.fetchFirst(
      tableName: _tagsTable.tableName,
      where: '${_tagsTable.id} = ?',
      whereArgs: [tagId],
    );

    if (tagRow != null) {
      final parsed = Map<String, dynamic>.from(tagRow);
      parsed['shared'] = parsed['shared'] == 1;
      parsed['remove_on_resolution'] = parsed['remove_on_resolution'] == 1;
      parsed['favorite'] = parsed['favorite'] == 1;
      parsed['tag_permissions'] = tagPermissionsList;
      parsed['tag_subscriptions'] = tagSubscriptionsList;
      return TagModel.fromJson(parsed);
    }

    throw Exception('Failed to create tag locally');
  }

  @override
  Future<List<Map<String, dynamic>>> getProjectMembers({
    required String projectId,
  }) async {
    final rows = _sqlite.query(
      table:
          'project_members', // Assuming it's already registered by Projects feature
      where: 'project_id = ?',
      whereArgs: [projectId],
    );
    return rows;
  }

  @override
  Future<bool> isTagNameUnique({
    required String name,
    required String projectId,
  }) async {
    final rows = _sqlite.query(
      table: _tagsTable.tableName,
      where: '${_tagsTable.projectId} = ? AND ${_tagsTable.name} LIKE ?',
      whereArgs: [projectId, name],
    );
    return rows.isEmpty;
  }
}
