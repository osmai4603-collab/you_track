import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class UsersTable extends TableById implements SqliteTable {
  const UsersTable();

  @override
  String get tableName => 'users';

  @override
  String get id => 'id';

  String get displayName => 'display_name';
  String get username => 'username';
  String get email => 'email';
  String get avatarUrl => 'avatar_url';
  String get registrationDate => 'created_at';
  String get isBanned => 'is_banned';
  String get groups => 'groups';
  String get projects => 'projects';

  @override
  List<String> get columns => [
        id,
        displayName,
        username,
        email,
        avatarUrl,
        registrationDate,
        isBanned,
        groups,
        projects,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $displayName TEXT,
      $username TEXT,
      $email TEXT,
      $avatarUrl TEXT,
      $registrationDate TEXT,
      $isBanned INTEGER DEFAULT 0,
      $groups TEXT,
      $projects TEXT
    )
  ''';
}
