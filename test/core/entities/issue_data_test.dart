import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/core/models/issue_data_model.dart';

void main() {
  test('IssueDataModel.fromJson maps Supabase issue payload', () {
    final issue = IssueDataModel.fromJson({
      'id': 'issue-1',
      'summary': 'Test issue',
      'issue_key': 'DEMO-16',
    });

    expect(issue.id, 'issue-1');
    expect(issue.summary, 'Test issue');
    expect(issue.issueKey, 'DEMO-16');
  });
}
