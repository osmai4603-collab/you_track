import 'package:issues_tracking/core/entities/entity.dart';

class UserData extends Entity {
  final String id;
  final String userName;
  final String email;
  final String? avatarUrl;

  const UserData({
    required this.id,
    required this.avatarUrl,
    required this.email,
    required this.userName,
  });

  @override
  UserData copyWith({
    String? id,
    String? userName,
    String? email,
    String? avatarUrl,
  }) {
    return UserData(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, userName, email, avatarUrl];
}
