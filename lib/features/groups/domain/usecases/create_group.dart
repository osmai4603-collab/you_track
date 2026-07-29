import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/domain/repositories/groups_repository.dart';

class CreateGroupParams extends Params {
  final String name;
  final String? description;

  const CreateGroupParams({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class CreateGroup extends UseCase<GroupEntity, CreateGroupParams> {
  final GroupsRepository repository;

  CreateGroup(this.repository);

  @override
  Future<Either<Failure, GroupEntity>> call({required CreateGroupParams params}) {
    return repository.createGroup(
      GroupEntity(
        id: '',
        name: params.name,
        description: params.description,
      ),
    );
  }
}
