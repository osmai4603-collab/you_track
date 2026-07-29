import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class DeleteGroupParams extends Params {
  final String id;

  const DeleteGroupParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteGroup extends UseCase<void, DeleteGroupParams> {
  final GroupsRepository repository;

  DeleteGroup(this.repository);

  @override
  Future<Either<Failure, void>> call({required DeleteGroupParams params}) {
    return repository.deleteGroup(params.id);
  }
}
