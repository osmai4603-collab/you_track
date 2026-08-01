import 'package:issues_tracking/core/entities/issue_data.dart';

final class IssueDataModel extends IssueData {
  const IssueDataModel({
    required super.id,
    required super.summary,
    required super.issueKey,
  });

  factory IssueDataModel.fromJson(Map<String, dynamic> data) {
    return IssueDataModel(
      id: data['id'],
      summary: data['summary'],
      issueKey: data['issue_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'summary': summary, 'issue_key': issueKey};
  }
}
