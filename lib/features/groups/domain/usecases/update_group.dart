import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';

import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class UpdateGroupParams extends Params {
  final String id;
  final String name;
  final String? description;
  final bool? autoJoin;
  final List<String>? autoJoinDomains;
  final String? twoFactorAuth;
  final String? groupType;
  final String? logo;

  const UpdateGroupParams({
    required this.id,
    required this.name,
    this.description,
    this.autoJoin,
    this.autoJoinDomains,
    this.twoFactorAuth,
    this.groupType,
    this.logo,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    autoJoin,
    autoJoinDomains,
    twoFactorAuth,
    groupType,
    logo,
  ];
}

class UpdateGroup extends UseCasePermission<GroupEntity, UpdateGroupParams> {
  final GroupsRepository repository;

  UpdateGroup(this.repository);

  @override
  Permission get requiredPermission => Permission.systemLowLevelAdminWrite;

  @override
  Future<Either<Failure, GroupEntity>> call({
    required UpdateGroupParams params,
  }) async {
    final result = await hasPermission();
    return result.fold((left) => Left(left), (right) async {
      return await repository.updateGroup(
        GroupEntity(
          id: params.id,
          name: params.name,
          description: params.description,
          autoJoin: params.autoJoin ?? false,
          autoJoinDomains: params.autoJoinDomains ?? const [],
          twoFactorAuth: params.twoFactorAuth ?? 'optional',
          groupType: params.groupType ?? 'users',
          logo: params.logo,
        ),
      );
    });
  }
}
