import 'package:equatable/equatable.dart';
import 'package:youtrack_api/src/models/models.dart';

class UserAuth extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;

  const UserAuth({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.tokenType,
    required this.user,
  });

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    tokenType,
    expiresIn,
    user,
  ];

  factory UserAuth.fromJson(Map<String, dynamic> data) {
    // The account is published under "user"; "user_id" is the legacy key kept
    // for older servers, so accept either.
    final rawUser = data['user'] ?? data['user_id'];
    if (rawUser is! Map) {
      throw FormatException(
        'login response is missing the "user" object',
        data.toString(),
      );
    }
    final user = Map<String, dynamic>.from(rawUser);

    return UserAuth(
      accessToken: (data['access_token'] ?? '').toString(),
      refreshToken: (data['refresh_token'] ?? '').toString(),
      tokenType: (data['token_type'] ?? 'Bearer').toString(),
      expiresIn: (data['expires_in'] as num?)?.toInt() ?? 0,
      user: UserModel.fromJson(user),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user_id': user.toJson(),
    };
  }
}
