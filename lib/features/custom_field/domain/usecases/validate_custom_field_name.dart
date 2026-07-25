import '../repositories/custom_field_repository.dart';

class ValidateCustomFieldName {
  final CustomFieldRepository repository;

  ValidateCustomFieldName(this.repository);

  Future<bool> call({
    required String projectId,
    required String name,
  }) async {
    return await repository.validateFieldNameUniqueness(
      projectId: projectId,
      name: name,
    );
  }
}