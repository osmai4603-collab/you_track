import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/build.dart';
import '../repositories/issues_repository.dart';

class GetBuildsParams extends Params {
  final String projectId;
  const GetBuildsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetBuildsUseCase implements UseCase<List<Build>, GetBuildsParams> {
  final IssuesRepository repository;

  GetBuildsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Build>>> call({required GetBuildsParams params}) {
    return repository.getBuilds(params.projectId);
  }
}
