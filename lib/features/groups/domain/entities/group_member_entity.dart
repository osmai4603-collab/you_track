import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/entities/user_data.dart';

class GroupMemberEntity extends Entity {
  final String id;
  final String userId;
  final String groupId;
  final UserData? user;

  const GroupMemberEntity({
    required this.id,
    required this.userId,
    required this.groupId,
    this.user,
  });

  @override
  GroupMemberEntity copyWith({
    String? id,
    String? userId,
    String? groupId,
    UserData? user,
  }) {
    return GroupMemberEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [id, userId, groupId, user];
}
