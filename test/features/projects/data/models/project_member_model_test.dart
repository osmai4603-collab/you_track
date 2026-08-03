import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/features/projects/data/models/project_member_model.dart';

void main() {
  test('handles null group payloads without throwing', () {
    final members = ProjectMemberModel.fromListJson([
      {'groups': null},
      {'groups': {'id': 'g1'}},
    ]);

    expect(members, hasLength(2));
    expect(members.first.id, isEmpty);
  });
}
