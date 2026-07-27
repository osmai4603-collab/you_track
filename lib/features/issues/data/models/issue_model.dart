import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';

import '../../domain/entities/issue.dart';

class IssueModel extends Issue {
  const IssueModel({
    required super.id,
    required super.issueKey,
    required super.issueNumber,
    required super.summary,
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
    super.visibility,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: (json['id'] ?? '').toString(),
      issueKey: (json['issue_key'] ?? '').toString(),
      issueNumber: (json['issue_sequence'] ?? 0) as int,
      summary: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      state: IssueStateEnum.of(json['state']),
      priority: IssuePriorityTypeEnum.of(json['priority']),
      issueType: IssueTypeEnum.of(json['issue_type']),
      assigneeId: json['assignee_id']?.toString(),
      assigneeName: json['assignee_name']?.toString(),
      assigneeAvatarUrl: json['assignee_avatar_url']?.toString(),
      reporterId: (json['reporter_id'] ?? '').toString(),
      reporterName: (json['reporter_name'] ?? '').toString(),
      tags: _parseList(json['tags']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'].toString())
          : null,
      estimation: json['estimation'] != null
          ? Duration(minutes: json['estimation'] as int)
          : null,
      spentTime: json['spent_time'] != null
          ? Duration(minutes: json['spent_time'] as int)
          : null,
      votes: (json['votes'] ?? 0) as int,
      watchersCount: (json['watchers_count'] ?? 0) as int,
      attachmentsCount: (json['attachments_count'] ?? 0) as int,
      commentsCount: (json['comments_count'] ?? 0) as int,
      isStarred: json['is_starred'] == true,
      parentId: json['parent_id']?.toString(),
      visibility: _parseList(json['visibility']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issue_key': issueKey,
      'issue_sequence': issueNumber,
      'title': summary,
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
      'visibility': visibility,
    };
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
