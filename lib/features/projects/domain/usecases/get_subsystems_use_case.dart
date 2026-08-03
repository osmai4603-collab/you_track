import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
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

class GetSubsystemsUseCase
    extends UseCase<List<SubsystemEntity>, GetSubsystemsParams> {
  final ProjectsRepository repository;

  GetSubsystemsUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetSubsystemsParams params) => params.projectId;

  @override
  Future<Either<Failure, List<SubsystemEntity>>> call({
    required GetSubsystemsParams params,
  }) {
    return repository.getSubsystems(params.projectId);
  }
}

class AddSubsystemUseCase extends UseCase<SubsystemEntity, AddSubsystemParams> {
  final ProjectsRepository repository;

  AddSubsystemUseCase(this.repository);

  // @override
  // Permission get requiredPermission => Permission.projectReadProjectBasic;

  // @override
  // String? getProjectId(AddSubsystemParams params) => params.subsystem.projectId;

  @override
  Future<Either<Failure, SubsystemEntity>> call({
    required AddSubsystemParams params,
  }) {
    return repository.addSubsystem(params.subsystem);
  }
}

class AddSubsystemParams extends Params {
  final SubsystemEntity subsystem;

  const AddSubsystemParams({required this.subsystem});

  @override
  List<Object?> get props => [subsystem];
}
