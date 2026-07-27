import 'package:equatable/equatable.dart';

class VcsUserMappingEntity extends Equatable {
  final String id;
  final String integrationId;
  final String vcsUsernameOrEmail;
  final String youtrackUserId;
  final DateTime createdAt;

  const VcsUserMappingEntity({
    required this.id,
    required this.integrationId,
    required this.vcsUsernameOrEmail,
    required this.youtrackUserId,
    required this.createdAt,
  });

  VcsUserMappingEntity copyWith({
    String? id,
    String? integrationId,
    String? vcsUsernameOrEmail,
    String? youtrackUserId,
    DateTime? createdAt,
  }) {
    return VcsUserMappingEntity(
      id: id ?? this.id,
      integrationId: integrationId ?? this.integrationId,
      vcsUsernameOrEmail: vcsUsernameOrEmail ?? this.vcsUsernameOrEmail,
      youtrackUserId: youtrackUserId ?? this.youtrackUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        integrationId,
        vcsUsernameOrEmail,
        youtrackUserId,
        createdAt,
      ];
}
