import '../../domain/entities/issue.dart';
import '../../domain/entities/issue_priority.dart';
import '../../domain/entities/issue_state.dart';
import '../../domain/entities/issue_type.dart';

class IssueModel extends Issue {
  const IssueModel({
    required super.id,
    required super.projectKey,
    required super.issueNumber,
    required super.title,
    super.description,
    super.state,
    super.priority,
    super.issueType,
    super.assigneeId,
    super.assigneeName,
    super.assigneeAvatarUrl,
    required super.reporterId,
    required super.reporterName,
    super.tags,
    required super.createdAt,
    required super.updatedAt,
    super.dueDate,
    super.estimation,
    super.spentTime,
    super.votes,
    super.watchersCount,
    super.attachmentsCount,
    super.commentsCount,
    super.isStarred,
    super.parentId,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: (json['id'] ?? '').toString(),
      projectKey: (json['project_key'] ?? '').toString(),
      issueNumber: (json['issue_number'] ?? 0) as int,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      state: _parseState(json['state']),
      priority: _parsePriority(json['priority']),
      issueType: _parseType(json['issue_type']),
      assigneeId: json['assignee_id']?.toString(),
      assigneeName: json['assignee_name']?.toString(),
      assigneeAvatarUrl: json['assignee_avatar_url']?.toString(),
      reporterId: (json['reporter_id'] ?? '').toString(),
      reporterName: (json['reporter_name'] ?? '').toString(),
      tags: _parseList(json['tags']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'].toString()) : null,
      estimation: json['estimation'] != null ? Duration(minutes: json['estimation'] as int) : null,
      spentTime: json['spent_time'] != null ? Duration(minutes: json['spent_time'] as int) : null,
      votes: (json['votes'] ?? 0) as int,
      watchersCount: (json['watchers_count'] ?? 0) as int,
      attachmentsCount: (json['attachments_count'] ?? 0) as int,
      commentsCount: (json['comments_count'] ?? 0) as int,
      isStarred: json['is_starred'] == true,
      parentId: json['parent_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_key': projectKey,
      'issue_number': issueNumber,
      'title': title,
      'description': description,
      'state': state.name,
      'priority': priority.name,
      'issue_type': issueType.name,
      'assignee_id': assigneeId,
      'assignee_name': assigneeName,
      'assignee_avatar_url': assigneeAvatarUrl,
      'reporter_id': reporterId,
      'reporter_name': reporterName,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'estimation': estimation?.inMinutes,
      'spent_time': spentTime?.inMinutes,
      'votes': votes,
      'watchers_count': watchersCount,
      'attachments_count': attachmentsCount,
      'comments_count': commentsCount,
      'is_starred': isStarred,
      'parent_id': parentId,
    };
  }

  static IssueTrackState _parseState(dynamic value) {
    if (value == null) return IssueTrackState.open;
    return IssueTrackState.values.firstWhere(
      (e) => e.name == value.toString(),
      orElse: () => IssueTrackState.open,
    );
  }

  static IssuePriority _parsePriority(dynamic value) {
    if (value == null) return IssuePriority.normal;
    return IssuePriority.values.firstWhere(
      (e) => e.name == value.toString(),
      orElse: () => IssuePriority.normal,
    );
  }

  static IssueType _parseType(dynamic value) {
    if (value == null) return IssueType.task;
    return IssueType.values.firstWhere(
      (e) => e.name == value.toString(),
      orElse: () => IssueType.task,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static List<String> _parseList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }
}
