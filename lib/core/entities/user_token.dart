import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';

class UserToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserEntity user;

  const UserToken({
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
}
