import 'package:issues_tracking/core/enums/issue_link_type.dart';
import '../../domain/entities/issue_link.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class IssueLinkModel extends IssueLink {
  const IssueLinkModel({
    required super.id,
    required super.issueId,
    required super.linkType,
    required super.issueLinkedId,
  });

  factory IssueLinkModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'IssueLink', data: json);
    return IssueLinkModel(
      id: (json['id'] ?? '').toString(),
      issueId: (json['source_issue_id'] ?? json['issue_id'] ?? '').toString(),
      linkType: IssueLinkType.of(json['link_type']?.toString() ?? ''),
      issueLinkedId: (json['target_issue_id'] ?? json['issue_linked_id'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'source_issue_id': issueId,
      'link_type': linkType.name,
      'target_issue_id': issueLinkedId,
    };
  }
}
