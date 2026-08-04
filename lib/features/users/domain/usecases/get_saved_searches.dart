import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class GetSavedSearchesParams extends Params {
  final String userId;
  const GetSavedSearchesParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetSavedSearchesUseCase
    extends UseCase<List<SavedSearchEntity>, GetSavedSearchesParams> {
  final UserProfileRepository repository;
  GetSavedSearchesUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, List<SavedSearchEntity>>> call({
    required GetSavedSearchesParams params,
  }) {
    return repository.getSavedSearches(params.userId);
  }
}