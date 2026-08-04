import 'package:issues_tracking/core/services/sqlite/migrations/sqlite_migrations.dart';
import 'package:sqlite3/sqlite3.dart';

/// Adds the `role` column to `project_members` so member roles are persisted
/// locally, matching the remote `project_members.role` column.
class ProjectMembersRoleMigration implements SqliteMigration {
  @override
  int get version => 15;

  @override
  void execute(Database db) {
    db.execute('ALTER TABLE project_members ADD COLUMN role TEXT DEFAULT ""');
  }
}
