import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/subsystem_entity.dart';
import '../repositories/projects_repository.dart';

class GetSubsystemsParams extends Params {
  final String projectId;
  const GetSubsystemsParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class GetSubsystemsUseCase implements UseCase<List<SubsystemEntity>, GetSubsystemsParams> {
  final ProjectsRepository repository;

  GetSubsystemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SubsystemEntity>>> call({required GetSubsystemsParams params}) {
    return repository.getSubsystems(params.projectId);
  }
}
