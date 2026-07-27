import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/issue_link_type.dart';

class IssueLink extends Entity {
  final String id;
  final String issueId;
  final IssueLinkType linkType;
  final String issueLinkedId;

  const IssueLink({
    required this.id,
    required this.issueId,
    required this.linkType,
    required this.issueLinkedId,
  });

  @override
  Entity copyWith({
    String? id,
    String? issueId,
    IssueLinkType? linkType,
    String? issueLinkedId,
  }) {
    return IssueLink(
      id: id ?? this.id,
      issueId: issueId ?? this.issueId,
      linkType: linkType ?? this.linkType,
      issueLinkedId: issueLinkedId ?? this.issueLinkedId,
    );
  }

  @override
  List<Object?> get props => [id, issueId, linkType, issueLinkedId];
}
