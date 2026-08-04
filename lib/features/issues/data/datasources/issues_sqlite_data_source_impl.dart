import 'dart:convert';
import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/builds_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_links_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_sprints_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issue_tags_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/issues_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/sprints_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/tags_table.dart';
import 'package:issues_tracking/features/issues/data/datasources/issues_remote_data_source.dart';
import 'package:issues_tracking/features/issues/data/models/build_model.dart';
import 'package:issues_tracking/features/issues/data/models/issue_link_model.dart';
import 'package:issues_tracking/features/issues/data/models/issue_model.dart';
import 'package:issues_tracking/features/issues/data/models/sprint_model.dart';
import 'package:issues_tracking/features/issues/data/models/tag_model.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';

class IssuesSqliteDataSourceImpl implements IssuesRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final IssuesTable _issuesTable = const IssuesTable();
  final TagsTable _tagsTable = const TagsTable();
  final IssueTagsTable _issueTagsTable = const IssueTagsTable();
  final SprintsTable _sprintsTable = const SprintsTable();
  final IssueSprintsTable _issueSprintsTable = const IssueSprintsTable();
  final BuildsTable _buildsTable = const BuildsTable();
  final IssueLinksTable _issueLinksTable = const IssueLinksTable();

  IssuesSqliteDataSourceImpl(this._sqlite);

  @override
  Future<BuildModel> createBuild(Map<String, dynamic> buildData) async {
    final json = Map<String, dynamic>.of(buildData);
    if (!json.containsKey('id') ||
        json['id'] == null ||
        json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    _sqlite.insert(table: _buildsTable.tableName, data: json);
    return BuildModel.fromJson(json);
  }

  @override
  Future<IssueModel> createIssue(IssueModel issue) async {
    final json = issue.toJson();
    final sprints = issue.sprints;
    final tags = issue.tags;
    final links = issue.links;

    json.remove('sprints');
    json.remove('tags');
    json.remove('issue_links');

    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    if (json['visibility'] != null) {
      json['visibility'] = jsonEncode(json['visibility']);
    }

    if (json.containsKey('is_starred') && json['is_starred'] is bool) {
      json['is_starred'] = json['is_starred'] ? 1 : 0;
    }

    _sqlite.insert(table: _issuesTable.tableName, data: json);

    final issueId = json['id'].toString();

    // Handling Sprints
    for (final sprint in sprints) {
      final s = sprint as SprintModel;
      _sqlite.insert(
        table: _issueSprintsTable.tableName,
        data: {'issue_id': issueId, 'sprint_id': s.id},
      );
    }

    // Handling Tags
    for (final tag in tags) {
      final t = tag as TagModel;
      _sqlite.insert(
        table: _issueTagsTable.tableName,
        data: {'issue_id': issueId, 'tag_id': t.id},
      );
    }

    // Handling Links
    for (final link in links) {
      final l = link as IssueLinkModel;
      _sqlite.insert(table: _issueLinksTable.tableName, data: l.toJson());
    }

    return getIssueById(issueId);
  }

  @override
  Future<void> deleteAttachment(String storagePath) async {
    // In SQLite mode, we just print or ignore since there is no local storage configured for attachments natively.
    print('Deleted mock attachment: $storagePath');
  }

  @override
  Future<void> deleteIssue(String issueId) async {
    _sqlite.execute(
      'DELETE FROM ${_issuesTable.tableName} WHERE ${_issuesTable.id} = ?',
      [issueId],
    );
    _sqlite.execute(
      'DELETE FROM ${_issueSprintsTable.tableName} WHERE ${_issueSprintsTable.issueId} = ?',
      [issueId],
    );
    _sqlite.execute(
      'DELETE FROM ${_issueTagsTable.tableName} WHERE ${_issueTagsTable.issueId} = ?',
      [issueId],
    );
    _sqlite.execute(
      'DELETE FROM ${_issueLinksTable.tableName} WHERE ${_issueLinksTable.sourceIssueId} = ?',
      [issueId],
    );
  }

  @override
  Future<List<TagModel>> getAllTags() async {
    final rows = _sqlite.query(table: _tagsTable.tableName);
    return rows.map((e) {
      final m = Map<String, dynamic>.from(e);
      m['shared'] = m['shared'] == 1;
      m['remove_on_resolution'] = m['remove_on_resolution'] == 1;
      m['favorite'] = m['favorite'] == 1;
      return TagModel.fromJson(m);
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getAttachments(String issueId) async {
    return []; // No local attachments mock implemented
  }

  @override
  Future<List<BuildModel>> getBuilds(String projectId) async {
    final rows = _sqlite.query(
      table: _buildsTable.tableName,
      where: '${_buildsTable.projectId} = ?',
      whereArgs: [projectId],
    );
    return rows.map((e) => BuildModel.fromJson(e)).toList();
  }

  @override
  Future<IssueModel> getIssueById(String id) async {
    final row = _sqlite.fetchFirst(
      tableName: _issuesTable.tableName,
      where: '${_issuesTable.id} = ?',
      whereArgs: [id],
    );
    if (row == null) {
      throw DatabaseException('Issue not found');
    }

    return _populateIssueRelations(row);
  }

  @override
  Future<List<IssueModel>> getProjectIssues(String projectId) async {
    final rows = _sqlite.query(
      table: _issuesTable.tableName,
      where: '${_issuesTable.projectId} = ?',
      whereArgs: [projectId],
      orderBy: 'created_at DESC',
    );

    final issues = <IssueModel>[];
    for (final row in rows) {
      final issue = Map<String, dynamic>.from(row);
      issues.add(await _populateIssueRelations(issue));
    }

    return issues;
  }

  @override
  Future<List<IssueModel>> getIssues(IssueFilter filter) async {
    List<String> conditions = [];
    List<dynamic> args = [];

    if (filter.projectFilter != null) {
      conditions.add('${_issuesTable.projectId} = ?');
      args.add(filter.projectFilter);
    }
    if (filter.stateFilter != null) {
      conditions.add('${_issuesTable.state} = ?');
      args.add(filter.stateFilter!.name);
    }
    if (filter.priorityFilter != null) {
      conditions.add('${_issuesTable.priority} = ?');
      args.add(filter.priorityFilter!.name);
    }
    if (filter.typeFilter != null) {
      conditions.add('${_issuesTable.issueType} = ?');
      args.add(filter.typeFilter!.name);
    }
    if (filter.searchQuery.isNotEmpty) {
      conditions.add(
        '(${_issuesTable.summary} LIKE ? OR ${_issuesTable.description} LIKE ?)',
      );
      args.add('%${filter.searchQuery}%');
      args.add('%${filter.searchQuery}%');
    }

    final whereClause = conditions.isEmpty ? null : conditions.join(' AND ');

    // Simplistic sorting
    String orderBy = 'created_at DESC';
    switch (filter.sortField) {
      case IssueSortField.updated:
        orderBy = 'updated_at ${filter.sortAscending ? 'ASC' : 'DESC'}';
        break;
      case IssueSortField.created:
        orderBy = 'created_at ${filter.sortAscending ? 'ASC' : 'DESC'}';
        break;
      case IssueSortField.priority:
        orderBy = 'priority ${filter.sortAscending ? 'ASC' : 'DESC'}';
        break;
      case IssueSortField.votes:
        orderBy = 'votes ${filter.sortAscending ? 'ASC' : 'DESC'}';
        break;
      case IssueSortField.summary:
        orderBy = 'summary ${filter.sortAscending ? 'ASC' : 'DESC'}';
        break;
    }

    final rows = _sqlite.query(
      table: _issuesTable.tableName,
      where: whereClause,
      whereArgs: args.isEmpty ? null : args,
      orderBy: orderBy,
    );

    List<IssueModel> issues = [];
    for (var row in rows) {
      issues.add(await _populateIssueRelations(row));
    }
    return issues;
  }

  Future<IssueModel> _populateIssueRelations(Map<String, dynamic> row) async {
    final parsed = Map<String, dynamic>.from(row);
    final issueId = parsed['id'].toString();

    // visibility parsing
    if (parsed['visibility'] != null && parsed['visibility'] is String) {
      try {
        parsed['visibility'] = jsonDecode(parsed['visibility']);
      } catch (_) {
        parsed['visibility'] = [];
      }
    }
    parsed['is_starred'] = parsed['is_starred'] == 1;

    // Fetch tags
    final tagLinks = _sqlite.query(
      table: _issueTagsTable.tableName,
      where: '${_issueTagsTable.issueId} = ?',
      whereArgs: [issueId],
    );
    final tagIds = tagLinks.map((l) => l['tag_id'].toString()).toList();
    if (tagIds.isNotEmpty) {
      final placeholders = List.filled(tagIds.length, '?').join(',');
      final tags = _sqlite.query(
        table: _tagsTable.tableName,
        where: '${_tagsTable.id} IN ($placeholders)',
        whereArgs: tagIds,
      );
      parsed['tags'] = tags.map((t) {
        final m = Map<String, dynamic>.from(t);
        m['shared'] = m['shared'] == 1;
        m['remove_on_resolution'] = m['remove_on_resolution'] == 1;
        m['favorite'] = m['favorite'] == 1;
        return m;
      }).toList();
    } else {
      parsed['tags'] = [];
    }

    // Fetch sprints
    final sprintLinks = _sqlite.query(
      table: _issueSprintsTable.tableName,
      where: '${_issueSprintsTable.issueId} = ?',
      whereArgs: [issueId],
    );
    final sprintIds = sprintLinks
        .map((l) => l['sprint_id'].toString())
        .toList();
    if (sprintIds.isNotEmpty) {
      final placeholders = List.filled(sprintIds.length, '?').join(',');
      final sprints = _sqlite.query(
        table: _sprintsTable.tableName,
        where: '${_sprintsTable.id} IN ($placeholders)',
        whereArgs: sprintIds,
      );
      parsed['sprints'] = sprints.map((s) {
        final m = Map<String, dynamic>.from(s);
        m['is_released'] = m['is_released'] == 1;
        return m;
      }).toList();
    } else {
      parsed['sprints'] = [];
    }

    // Fetch issue links
    final links = _sqlite.query(
      table: _issueLinksTable.tableName,
      where: '${_issueLinksTable.sourceIssueId} = ?',
      whereArgs: [issueId],
    );
    parsed['issue_links'] = links;

    // Fetch build if exists
    if (parsed['build_id'] != null) {
      final buildRow = _sqlite.fetchFirst(
        tableName: _buildsTable.tableName,
        where: '${_buildsTable.id} = ?',
        whereArgs: [parsed['build_id']],
      );
      if (buildRow != null) {
        parsed['build'] = buildRow;
      }
    }

    return IssueModel.fromJson(parsed);
  }

  @override
  Future<List<SprintModel>> getSprints(String projectId) async {
    final rows = _sqlite.query(
      table: _sprintsTable.tableName,
      where: '${_sprintsTable.projectId} = ?',
      whereArgs: [projectId],
    );
    return rows.map((e) {
      final m = Map<String, dynamic>.from(e);
      m['is_released'] = m['is_released'] == 1;
      return SprintModel.fromJson(m);
    }).toList();
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) async {
    final json = issue.toJson();
    final issueId = issue.id;

    json.remove('id');
    json.remove('sprints');
    json.remove('tags');
    json.remove('issue_links');
    json.remove('build'); // we don't save nested build obj here

    json['updated_at'] = DateTime.now().toIso8601String();

    if (json['visibility'] != null) {
      json['visibility'] = jsonEncode(json['visibility']);
    }

    if (json.containsKey('is_starred') && json['is_starred'] is bool) {
      json['is_starred'] = json['is_starred'] ? 1 : 0;
    }

    final setClause = json.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_issuesTable.tableName} SET $setClause WHERE ${_issuesTable.id} = ?',
      [...json.values, issueId],
    );

    // Replace sprints
    _sqlite.execute(
      'DELETE FROM ${_issueSprintsTable.tableName} WHERE ${_issueSprintsTable.issueId} = ?',
      [issueId],
    );
    for (final sprint in issue.sprints) {
      final s = sprint as SprintModel;
      _sqlite.insert(
        table: _issueSprintsTable.tableName,
        data: {'issue_id': issueId, 'sprint_id': s.id},
      );
    }

    // Replace tags
    _sqlite.execute(
      'DELETE FROM ${_issueTagsTable.tableName} WHERE ${_issueTagsTable.issueId} = ?',
      [issueId],
    );
    for (final tag in issue.tags) {
      final t = tag as TagModel;
      _sqlite.insert(
        table: _issueTagsTable.tableName,
        data: {'issue_id': issueId, 'tag_id': t.id},
      );
    }

    // Replace links
    _sqlite.execute(
      'DELETE FROM ${_issueLinksTable.tableName} WHERE ${_issueLinksTable.sourceIssueId} = ?',
      [issueId],
    );
    for (final link in issue.links) {
      final l = link as IssueLinkModel;
      _sqlite.insert(table: _issueLinksTable.tableName, data: l.toJson());
    }

    return getIssueById(issueId);
  }

  @override
  Future<void> updateIssueStarred(String issueId, bool isStarred) async {
    _sqlite.execute(
      'UPDATE ${_issuesTable.tableName} SET is_starred = ? WHERE ${_issuesTable.id} = ?',
      [isStarred ? 1 : 0, issueId],
    );
  }

  @override
  Future<String> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    if (onProgress != null) onProgress(1.0);
    return 'issues/$issueId/$fileName';
  }

  @override
  Stream<IssueModel> streamIssues(IssueFilter filter) {
    // TODO: implement streamIssues
    throw UnimplementedError();
  }
}
