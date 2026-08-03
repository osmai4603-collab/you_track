import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/board_card.dart';
import 'package:issues_tracking/core/utils/printing.dart';
import 'package:issues_tracking/features/projects/data/models/subsystem_model.dart';

class BoardCardModel extends BoardCard {
  const BoardCardModel({
    required super.id,
    required super.issueKey,
    required super.summary,
    required super.state,
    super.priority,
    super.issueType,
    required super.subsystem,
    super.assigneeAvatarUrl,
    super.assigneeName,
    super.estimation,
    super.totalSubtasks,
    super.completedSubtasks,
  });

  factory BoardCardModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'BoardCard', data: json);
    return BoardCardModel(
      id: (json['id'] ?? '').toString(),
      issueKey: (json['issue_key'] ?? '').toString(),
      summary: (json['summary'] ?? '').toString(),
      state: IssueStateEnum.of(json['state']),
      priority: IssuePriorityTypeEnum.of(json['priority']),
      issueType: json['issue_type'] != null
          ? IssueTypeEnum.of(json['issue_type'])
          : IssueTypeEnum.task,
      subsystem: SubsystemModel.fromJson(
        (json['subsystem'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      assigneeAvatarUrl: json['assignee_avatar_url']?.toString(),
      assigneeName: json['assignee_name']?.toString(),
      estimation: json['estimation'] != null
          ? Duration(minutes: json['estimation'] as int)
          : null,
      totalSubtasks: 0,
      completedSubtasks: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'issue_key': issueKey,
      'summary': summary,
      'state': state.name,
      'priority': priority.name,
      'issue_type': issueType.name,
      'subsystem': subsystem.name,
      'assignee_avatar_url': assigneeAvatarUrl,
      'assignee_name': assigneeName,
      'estimation': estimation?.inMinutes,
    };
  }

  static BoardCardModel fromEntity(BoardCard entity) {
    return BoardCardModel(
      id: entity.id,
      issueKey: entity.issueKey,
      summary: entity.summary,
      state: entity.state,
      priority: entity.priority,
      issueType: entity.issueType,
      subsystem: entity.subsystem,
      assigneeAvatarUrl: entity.assigneeAvatarUrl,
      assigneeName: entity.assigneeName,
      estimation: entity.estimation,
      totalSubtasks: entity.totalSubtasks,
      completedSubtasks: entity.completedSubtasks,
    );
  }
}
