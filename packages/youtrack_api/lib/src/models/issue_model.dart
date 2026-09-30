import 'package:equatable/equatable.dart';
import 'package:youtrack_api/src/models/json_pick.dart';

/// An issue as returned by `GET /issues`, `GET /issues/{issueID}` and
/// `GET /projects/{projectID}/issues`.
///
/// The wire format is snake_case and the field names are not the database
/// column names: the server sends `issue_key` where the column is `id_readable`,
/// and `issue_sequence` where it is `number_in_project`. That is deliberate on
/// the server side and this parser matches it exactly.
///
/// [state], [priority] and [issueType] are kept as Strings rather than enums
/// because the corresponding enums live in the app layer, which this package
/// cannot import. The app maps them when it builds the domain entity.
///
/// Parsing is defensive in the same way [ProjectModel] is: a missing or
/// unexpected field degrades to a safe default instead of throwing. An issue
/// list is the app's main screen, so one malformed row must not take the screen
/// down with it.
class IssueModel extends Equatable {
  final String id;
  final String projectId;

  /// The human-readable key, e.g. `DEMO-1`.
  final String issueKey;

  /// The issue's number within its project. Sent as `issue_sequence`.
  final int issueNumber;

  final String summary;
  final String description;

  /// One of `to-do`, `in-progress`, `done`.
  final String state;

  /// One of `show-stopper`, `critical`, `major`, `normal`, `minor`.
  ///
  /// The app's priority enum throws on an unrecognised value rather than
  /// falling back, which is why the server constrains this column with a CHECK
  /// constraint. This parser only guarantees a non-empty string.
  final String priority;

  /// One of `bug`, `cosmetic`, `exception`, `feature`, `task`,
  /// `usability-problem`, `performance-problem`, `epic`.
  final String issueType;

  final String? assigneeId;
  final String? reporterId;
  final String? subsystemId;
  final String? parentId;
  final String fixVersions;
  final String? buildId;
  final String? assigneeAvatarUrl;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;

  /// Effort figures, in minutes, as the server stores them. The app converts
  /// them to `Duration`.
  final int? estimationMinutes;
  final int? spentTimeMinutes;

  final int votes;
  final int watchersCount;
  final int attachmentsCount;
  final int commentsCount;
  final bool isStarred;

  /// The server currently sends these three as empty, because the underlying
  /// tables do not carry the fields the app's tag, sprint and link models
  /// require. They are parsed when present so the shapes are already correct
  /// once the server can source them.
  final List<Map<String, dynamic>> tags;
  final List<Map<String, dynamic>> sprints;
  final List<Map<String, dynamic>> issueLinks;

  /// Group name to member ids, e.g. `{'users': [], 'groups': []}`.
  final Map<String, List<String>> visibility;

  const IssueModel({
    required this.id,
    required this.projectId,
    required this.issueKey,
    required this.issueNumber,
    required this.summary,
    this.description = '',
    this.state = 'to-do',
    this.priority = 'normal',
    this.issueType = 'task',
    this.assigneeId,
    this.reporterId,
    this.subsystemId,
    this.parentId,
    this.fixVersions = '',
    this.buildId,
    this.assigneeAvatarUrl,
    this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.estimationMinutes,
    this.spentTimeMinutes,
    this.votes = 0,
    this.watchersCount = 0,
    this.attachmentsCount = 0,
    this.commentsCount = 0,
    this.isStarred = false,
    this.tags = const [],
    this.sprints = const [],
    this.issueLinks = const [],
    this.visibility = const {'users': [], 'groups': []},
  });

  factory IssueModel.fromJson(Map<String, dynamic> data) {
    return IssueModel(
      id: pickString(data, const ['id']),
      projectId: pickString(data, const ['project_id', 'projectId']),
      issueKey: pickString(data, const ['issue_key', 'id_readable']),
      issueNumber: pickInt(data, const [
        'issue_sequence',
        'number_in_project',
      ]),
      summary: pickString(data, const ['summary']),
      description: pickString(data, const ['description']),
      state: pickString(data, const ['state']),
      priority: pickString(data, const ['priority']),
      issueType: pickString(data, const ['issue_type', 'issueType']),
      assigneeId: pickNullableString(data, const ['assignee_id']),
      reporterId: pickNullableString(data, const ['reporter_id']),
      subsystemId: pickNullableString(data, const ['subsystem_id']),
      parentId: pickNullableString(data, const ['parent_id']),
      fixVersions: pickString(data, const ['fix_versions']),
      buildId: pickNullableString(data, const ['build_id']),
      assigneeAvatarUrl: pickNullableString(data, const [
        'assignee_avatar_url',
      ]),
      createdAt: pickDate(data, const ['created_at']),
      updatedAt: pickDate(data, const ['updated_at']),
      dueDate: pickDate(data, const ['due_date']),
      estimationMinutes: pickNullableInt(data, const ['estimation']),
      spentTimeMinutes: pickNullableInt(data, const ['spent_time']),
      votes: pickInt(data, const ['votes']),
      watchersCount: pickInt(data, const ['watchers_count']),
      attachmentsCount: pickInt(data, const ['attachments_count']),
      commentsCount: pickInt(data, const ['comments_count']),
      isStarred: pickBool(data, const ['is_starred']),
      tags: pickMapList(data, const ['tags']),
      sprints: pickMapList(data, const ['sprints']),
      issueLinks: pickMapList(data, const ['issue_links']),
      visibility: _pickVisibility(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'issue_key': issueKey,
      'issue_sequence': issueNumber,
      'summary': summary,
      'description': description,
      'state': state,
      'priority': priority,
      'issue_type': issueType,
      'assignee_id': assigneeId,
      'reporter_id': reporterId,
      'subsystem_id': subsystemId,
      'parent_id': parentId,
      'fix_versions': fixVersions,
      'build_id': buildId,
      'assignee_avatar_url': assigneeAvatarUrl,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String(),
      'due_date': dueDate?.toUtc().toIso8601String(),
      'estimation': estimationMinutes,
      'spent_time': spentTimeMinutes,
      'votes': votes,
      'watchers_count': watchersCount,
      'attachments_count': attachmentsCount,
      'comments_count': commentsCount,
      'is_starred': isStarred,
      'tags': tags,
      'sprints': sprints,
      'issue_links': issueLinks,
      'visibility': visibility,
    };
  }

  /// `visibility` is a map of group name to member ids. A non-list value under
  /// any key is dropped rather than cast, because the app casts each value
  /// without checking and a null there would throw.
  static Map<String, List<String>> _pickVisibility(Map<String, dynamic> data) {
    const fallback = {'users': <String>[], 'groups': <String>[]};
    final value = data['visibility'];
    if (value is! Map) return fallback;

    final parsed = <String, List<String>>{};
    value.forEach((key, members) {
      if (members is List) {
        parsed[key.toString()] = members.map((e) => e.toString()).toList();
      }
    });
    return parsed.isEmpty ? fallback : parsed;
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    issueKey,
    issueNumber,
    summary,
    description,
    state,
    priority,
    issueType,
    assigneeId,
    reporterId,
    subsystemId,
    parentId,
    fixVersions,
    buildId,
    assigneeAvatarUrl,
    createdAt,
    updatedAt,
    dueDate,
    estimationMinutes,
    spentTimeMinutes,
    votes,
    watchersCount,
    attachmentsCount,
    commentsCount,
    isStarred,
    tags,
    sprints,
    issueLinks,
    visibility,
  ];
}
