import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class CustomFieldsTable extends TableById implements SqliteTable {
  const CustomFieldsTable();

  @override
  String get tableName => 'custom_fields';

  @override
  String get id => 'id';

  String get projectId => 'project_id';
  String get name => 'name';
  String get fieldType => 'field_type';
  String get fieldMode => 'field_mode';
  String get valueMode => 'value_mode';
  String get defaultValue => 'default_value';
  String get emptyValue => 'empty_value';
  String get canBeEmpty => 'can_be_empty';
  String get aliases => 'aliases';
  String get visibleTo => 'visible_to';
  String get updatableBy => 'updatable_by';
  String get showOnlyWhen => 'show_only_when';
  String get filterValuesBasedOn => 'filter_values_based_on';
  String get orderIndex => 'order_index';
  String get visibility => 'visibility';
  String get accessControl => 'access_control';
  String get createdAt => 'created_at';
  String get updatedAt => 'updated_at';

  @override
  List<String> get columns => [
    id,
    projectId,
    name,
    fieldType,
    fieldMode,
    valueMode,
    defaultValue,
    emptyValue,
    canBeEmpty,
    aliases,
    visibleTo,
    updatableBy,
    showOnlyWhen,
    filterValuesBasedOn,
    orderIndex,
    visibility,
    accessControl,
    createdAt,
    updatedAt,
  ];

  @override
  String get queryCreateTable =>
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $projectId TEXT NOT NULL,
      $name TEXT NOT NULL,
      $fieldType TEXT NOT NULL,
      $fieldMode TEXT,
      $valueMode TEXT,
      $defaultValue TEXT,
      $emptyValue TEXT,
      $canBeEmpty INTEGER DEFAULT 1,
      $aliases TEXT,
      $visibleTo TEXT,
      $updatableBy TEXT,
      $showOnlyWhen TEXT,
      $filterValuesBasedOn TEXT,
      $orderIndex INTEGER DEFAULT 0,
      $visibility TEXT,
      $accessControl TEXT,
      $createdAt TEXT NOT NULL,
      $updatedAt TEXT NOT NULL
    )
  ''';
}
