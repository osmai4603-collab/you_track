import 'package:issues_tracking/core/entities/entity.dart';

class IssueData extends Entity {
  final String id;
  final String summary;
  final String issueKey;

  const IssueData({
    required this.id,
    required this.summary,
    required this.issueKey,
  });
  @override
  IssueData copyWith({String? id, String? summary, String? issueKey}) {
    return IssueData(
      id: id ?? this.id,
      summary: summary ?? this.summary,
      issueKey: issueKey ?? this.issueKey,
    );
  }

  @override
  List<Object?> get props => [id, summary, issueKey];
}
