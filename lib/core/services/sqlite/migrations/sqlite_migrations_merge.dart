import 'package:issues_tracking/core/services/sqlite/migrations/sqlite_migration_v15_project_members_role.dart';
import 'package:issues_tracking/core/services/sqlite/migrations/sqlite_migrations.dart';

final List<SqliteMigration> sqliteMigrations = [
  ProjectMembersRoleMigration(),
];
