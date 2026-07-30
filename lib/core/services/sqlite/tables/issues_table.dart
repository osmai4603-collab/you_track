import 'package:issues_tracking/core/services/sqlite/table_by_id.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sqlite_table.dart';

class IssuesTable extends TableById implements SqliteTable {
  const IssuesTable();

  @override
  String get tableName => 'issues';

  @override
  String get id => 'id';

  String get issueKey => 'issue_key';
  String get issueNumber => 'issue_sequence';
  String get summary => 'summary';
  String get description => 'description';
  String get state => 'state';
  String get priority => 'priority';
  String get issueType => 'issue_type';
  String get assigneeId => 'assignee_id';
  String get assigneeName => 'assignee_name';
  String get assigneeAvatarUrl => 'assignee_avatar_url';
  String get reporterId => 'reporter_id';
  String get reporterName => 'reporter_name';
  String get subsystem => 'subsystem';
  String get fixVersions => 'fix_versions';
  String get buildId => 'build_id';
  String get createdAt => 'created_at';
  String get updatedAt => 'updated_at';
  String get dueDate => 'due_date';
  String get estimation => 'estimation';
  String get spentTime => 'spent_time';
  String get votes => 'votes';
  String get watchersCount => 'watchers_count';
  String get attachmentsCount => 'attachments_count';
  String get commentsCount => 'comments_count';
  String get isStarred => 'is_starred';
  String get parentId => 'parent_id';
  String get visibility => 'visibility';
  String get projectId => 'project_id';

  @override
  List<String> get columns => [
        id,
        issueKey,
        issueNumber,
        summary,
        description,
        state,
        priority,
        issueType,
        assigneeId,
        assigneeName,
        assigneeAvatarUrl,
        reporterId,
        reporterName,
        subsystem,
        fixVersions,
        buildId,
        createdAt,
        updatedAt,
        dueDate,
        estimation,
        spentTime,
        votes,
        watchersCount,
        attachmentsCount,
        commentsCount,
        isStarred,
        parentId,
        visibility,
        projectId,
      ];

  @override
  String get queryCreateTable => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id TEXT PRIMARY KEY NOT NULL,
      $issueKey TEXT NOT NULL,
      $issueNumber INTEGER NOT NULL,
      $summary TEXT NOT NULL,
      $description TEXT,
      $state TEXT NOT NULL,
      $priority TEXT NOT NULL,
      $issueType TEXT NOT NULL,
      $assigneeId TEXT,
      $assigneeName TEXT,
      $assigneeAvatarUrl TEXT,
      $reporterId TEXT NOT NULL,
      $reporterName TEXT NOT NULL,
      $subsystem TEXT,
      $fixVersions TEXT,
      $buildId TEXT,
      $createdAt TEXT NOT NULL,
      $updatedAt TEXT NOT NULL,
      $dueDate TEXT,
      $estimation INTEGER,
      $spentTime INTEGER,
      $votes INTEGER DEFAULT 0,
      $watchersCount INTEGER DEFAULT 0,
      $attachmentsCount INTEGER DEFAULT 0,
      $commentsCount INTEGER DEFAULT 0,
      $isStarred INTEGER DEFAULT 0,
      $parentId TEXT,
      $visibility TEXT,
      $projectId TEXT
    )
  ''';
}
