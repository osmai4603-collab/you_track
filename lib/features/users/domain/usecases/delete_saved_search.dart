import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/users/domain/repositories/user_profile_repository.dart';

class DeleteSavedSearchParams extends Params {
  final String searchId;
  const DeleteSavedSearchParams({required this.searchId});

  @override
  List<Object?> get props => [searchId];
}

class DeleteSavedSearchUseCase extends UseCase<void, DeleteSavedSearchParams> {
  final UserProfileRepository repository;
  DeleteSavedSearchUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.userProfileUpdateSelf;

  @override
  Future<Either<Failure, void>> call({
    required DeleteSavedSearchParams params,
  }) {
    return repository.deleteSavedSearch(params.searchId);
  }
}