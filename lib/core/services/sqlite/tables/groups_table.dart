import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class GroupsTable extends TableById implements SqliteTable {
  const GroupsTable();

  @override
  String get tableName => 'groups';

  @override
  String get id => 'id';

  String get name => 'name';
  String get description => 'description';
  String get logo => 'logo';
  String get autoJoin => 'auto_join';
  String get autoJoinDomains => 'auto_join_domains';
  String get twoFactorAuth => 'two_factor_auth';
  String get visibleTo => 'visible_to';
  String get updatableBy => 'updatable_by';
  String get groupType => 'group_type';
  String get createdAt => 'created_at';
  String get updatedAt => 'updated_at';

  @override
  List<String> get columns => [
    id,
    name,
    description,
    logo,
    autoJoin,
    autoJoinDomains,
    twoFactorAuth,
    visibleTo,
    updatableBy,
    groupType,
    createdAt,
    updatedAt,
  ];

  @override
  String get queryCreateTable =>
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $name TEXT NOT NULL,
      $description TEXT,
      $logo TEXT,
      $autoJoin INTEGER,
      $autoJoinDomains TEXT,
      $twoFactorAuth TEXT,
      $visibleTo TEXT,
      $updatableBy TEXT,
      $groupType TEXT,
      $createdAt TEXT,
      $updatedAt TEXT
    )
  ''';
}
