import 'package:issues_tracking/core/entities/user_data.dart';

final class UserDataModel extends UserData {
  const UserDataModel({
    required super.id,
    required super.avatarUrl,
    required super.email,
    required super.userName,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> data) {
    return UserDataModel(
      id: data['id'],
      userName: data['user_name'],
      avatarUrl: data['avatar_url'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}
