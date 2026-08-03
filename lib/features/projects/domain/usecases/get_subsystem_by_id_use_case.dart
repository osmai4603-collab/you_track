import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/subsystem_entity.dart';
import '../repositories/projects_repository.dart';

class GetSubsystemByIdParams extends Params {
  final String id;
  const GetSubsystemByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetSubsystemByIdUseCase
    extends UseCase<SubsystemEntity, GetSubsystemByIdParams> {
  final ProjectsRepository repository;

  GetSubsystemByIdUseCase(this.repository);

  @override
  Permission get requiredPermission => Permission.projectReadProjectBasic;

  @override
  String? getProjectId(GetSubsystemByIdParams params) => null;

  @override
  Future<Either<Failure, SubsystemEntity>> call({
    required GetSubsystemByIdParams params,
  }) {
    return repository.getSubsystemById(params.id);
  }
}
