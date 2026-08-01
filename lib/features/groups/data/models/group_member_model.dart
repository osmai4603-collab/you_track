import 'package:issues_tracking/core/entities/user_data.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    required super.id,
    required super.userId,
    required super.groupId,
    super.user,
  });

  factory GroupMemberModel.fromEntity(GroupMemberEntity entity) {
    return GroupMemberModel(
      id: entity.id,
      userId: entity.userId,
      groupId: entity.groupId,
      user: entity.user,
    );
  }

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'GroupMember', data: json);
    UserData? user;
    if (json['users'] != null) {
      final u = json['users'];
      user = UserData(
        id: (u['id'] ?? '').toString(),
        userName: (u['user_name'] ?? '').toString(),
        email: (u['email'] ?? '').toString(),
        avatarUrl: u['avatar_url']?.toString(),
      );
    }
    return GroupMemberModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      groupId: (json['group_id'] ?? '').toString(),
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'group_id': groupId,
    };
  }
}
