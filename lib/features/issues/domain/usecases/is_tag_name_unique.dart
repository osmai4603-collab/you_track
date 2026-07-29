import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import '../repositories/tags_repository.dart';

class IsTagNameUnique implements UseCase<bool, IsTagNameUniqueParams> {
  final TagsRepository repository;

  IsTagNameUnique(this.repository);

  @override
  Future<Either<Failure, bool>> call({required IsTagNameUniqueParams params}) {
    return repository.isTagNameUnique(name: params.name, projectId: params.projectId);
  }
}

class IsTagNameUniqueParams extends Params {
  final String name;
  final String projectId;

  const IsTagNameUniqueParams({required this.name, required this.projectId});

  @override
  List<Object?> get props => [name, projectId];
}
