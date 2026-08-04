import 'package:flutter/foundation.dart';
import 'package:issues_tracking/core/services/sqlite/migrations/sqlite_migrations_merge.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/roles_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/groups_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_members_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_projects_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/group_roles_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/users_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/projects_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/project_members_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/project_templates_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issues_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tags_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_tags_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_links_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sprints_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/builds_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_sprints_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_permissions_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_subscriptions_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_permission_users_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tag_permission_groups_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/dashboards_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/dashboard_widgets_table.dart';
import 'package:sqlite3/sqlite3.dart';

final class SqliteSchemaManager {
  const SqliteSchemaManager._();

  static const int currentVersion = 15;

  /// Create the full schema for a new database.
  static void createAll(Database db) {
    _createAllTables(db);
    createTriggers(db);
  }

  /// Apply incremental migrations from [fromVersion] (exclusive) up to [toVersion] (inclusive).
  static void migrate(Database db, int fromVersion, int toVersion) {
    if (fromVersion >= toVersion) return;
    db.execute('PRAGMA foreign_keys = OFF');
    try {
      for (var v = fromVersion + 1; v <= toVersion; v++) {
        db.execute('BEGIN');
        try {
          final migration = sqliteMigrations.firstWhere(
            (m) => m.version == v,
            orElse: () =>
                throw StateError('No migration defined for version $v'),
          );
          migration.execute(db);
          db.execute('COMMIT');
          debugPrint('Migration to version $v applied');
        } catch (e) {
          db.execute('ROLLBACK');
          debugPrint('Migration to version $v failed: $e');
          rethrow;
        }
      }
      // Recreate all triggers to ensure they are up-to-date with the latest code
      createTriggers(db);
    } finally {
      db.execute('PRAGMA foreign_keys = ON');
    }
  }

  // ---------------------------------------------------------------------------
  // Schema creation – all tables with their final structure
  // ---------------------------------------------------------------------------
  static void _createAllTables(Database db) {
    final tables = <SqliteTable>[
      const RolesTable(),
      const GroupsTable(),
      const GroupMembersTable(),
      const GroupProjectsTable(),
      const GroupRolesTable(),
      const UsersTable(),
      const ProjectsTable(),
      const ProjectMembersTable(),
      const ProjectTemplatesTable(),
      const IssuesTable(),
      const TagsTable(),
      const IssueTagsTable(),
      const IssueLinksTable(),
      const SprintsTable(),
      const BuildsTable(),
      const IssueSprintsTable(),
      const TagPermissionsTable(),
      const TagSubscriptionsTable(),
      const TagPermissionUsersTable(),
      const TagPermissionGroupsTable(),
      const DashboardsTable(),
      const DashboardWidgetsTable(),
    ];

    for (final table in tables) {
      db.execute(table.queryCreateTable);
    }
  }

  // ---------------------------------------------------------------------------
  // Triggers
  // ---------------------------------------------------------------------------
  static void createTriggers(Database db) {
    // Drop the deprecated inventories triggers
  }
}
