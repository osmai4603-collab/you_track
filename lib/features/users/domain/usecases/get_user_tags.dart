import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class GetUserTagsParams extends Params {
  final String userId;
  const GetUserTagsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetUserTagsUseCase extends UseCase<List<Tag>, GetUserTagsParams> {
  final UserProfileRepository repository;
  GetUserTagsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, List<Tag>>> call({
    required GetUserTagsParams params,
  }) {
    return repository.getUserTags(params.userId);
  }
}