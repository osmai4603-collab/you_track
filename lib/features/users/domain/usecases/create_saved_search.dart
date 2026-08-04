import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class CreateSavedSearchParams extends Params {
  final SavedSearchEntity search;
  const CreateSavedSearchParams({required this.search});

  @override
  List<Object?> get props => [search];
}

class CreateSavedSearchUseCase
    extends UseCase<SavedSearchEntity, CreateSavedSearchParams> {
  final UserProfileRepository repository;
  CreateSavedSearchUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, SavedSearchEntity>> call({
    required CreateSavedSearchParams params,
  }) {
    return repository.createSavedSearch(params.search);
  }
}