import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/features/issues/data/models/build_model.dart';
import 'package:issues_tracking/features/issues/data/models/sprint_model.dart';
import 'package:issues_tracking/features/issues/data/models/tag_model.dart';
import 'package:issues_tracking/features/issues/data/models/issue_link_model.dart';

import '../../domain/entities/issue.dart';
import 'package:issues_tracking/core/utils/printing.dart';

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
    super.subsystem,
    super.fixVersions,
    super.build,
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
    super.sprints,
    super.links,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'Issue', data: json);
    return IssueModel(
      id: (json['id'] ?? '').toString(),
      issueKey: (json['issue_key'] ?? '').toString(),
      issueNumber: (json['issue_sequence'] ?? 0) as int,
      summary: (json['summary'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      state: IssueStateEnum.of(json['state']),
      priority: IssuePriorityTypeEnum.of(json['priority']),
      issueType: IssueTypeEnum.of(json['issue_type']),
      assigneeId: json['assignee_id']?.toString(),
      assigneeName: json['assignee_name']?.toString(),
      assigneeAvatarUrl: json['assignee_avatar_url']?.toString(),
      reporterId: (json['reporter_id'] ?? '').toString(),
      reporterName: (json['reporter_name'] ?? '').toString(),
      subsystem: json['subsystem'] != null
          ? IssueSubsystemEnum.of(json['subsystem'])
          : IssueSubsystemEnum.noValue,
      fixVersions: (json['fix_versions'] ?? '').toString(),
      build: json['build'] != null
          ? BuildModel.fromJson(json['build'] as Map<String, dynamic>)
          : null,
      tags: (json['tags'] as List? ?? [])
          .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      sprints: (json['sprints'] as List? ?? [])
          .map((s) => SprintModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      links: (json['issue_links'] as List? ?? [])
          .map((l) => IssueLinkModel.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'issue_key': issueKey,
      'issue_sequence': issueNumber,
      'summary': summary,
      'description': description,
      'state': state.name,
      'priority': priority.name,
      'issue_type': issueType.name,
      'assignee_id': assigneeId,
      'assignee_name': assigneeName,
      'assignee_avatar_url': assigneeAvatarUrl,
      'reporter_id': reporterId,
      'reporter_name': reporterName,
      'subsystem': subsystem.name,
      'fix_versions': fixVersions,
      'build_id': build?.id,
      'tags': tags.map((t) => (t as TagModel).toJson()).toList(),
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
      'sprints': sprints
          .map((s) => (s as SprintModel).toJson())
          .toList(),
      'issue_links': links.map((l) => (l as IssueLinkModel).toJson()).toList(),
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

  static IssueModel fromEntity(Issue issue) {
    return IssueModel(
      id: issue.id,
      issueKey: issue.issueKey,
      issueNumber: issue.issueNumber,
      summary: issue.summary,
      description: issue.description,
      state: issue.state,
      priority: issue.priority,
      issueType: issue.issueType,
      assigneeId: issue.assigneeId,
      assigneeName: issue.assigneeName,
      assigneeAvatarUrl: issue.assigneeAvatarUrl,
      reporterId: issue.reporterId,
      reporterName: issue.reporterName,
      subsystem: issue.subsystem,
      fixVersions: issue.fixVersions,
      build: issue.build,
      tags: issue.tags,
      createdAt: issue.createdAt,
      updatedAt: issue.updatedAt,
      dueDate: issue.dueDate,
      estimation: issue.estimation,
      spentTime: issue.spentTime,
      votes: issue.votes,
      watchersCount: issue.watchersCount,
      attachmentsCount: issue.attachmentsCount,
      commentsCount: issue.commentsCount,
      isStarred: issue.isStarred,
      parentId: issue.parentId,
      visibility: issue.visibility,
      sprints: issue.sprints,
      links: issue.links,
    );
  }
}
