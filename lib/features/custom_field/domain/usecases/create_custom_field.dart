import '../entities/custom_field.dart';
import '../entities/field_type.dart';
import '../repositories/custom_field_repository.dart';

class CreateCustomField {
  final CustomFieldRepository repository;

  CreateCustomField(this.repository);

  Future<CustomField> call({
    required String projectId,
    required String name,
    String? description,
    required FieldType type,
    bool isPrivate = false,
  }) async {
    return await repository.createCustomField(
      projectId: projectId,
      name: name,
      description: description,
      type: type,
      isPrivate: isPrivate,
    );
  }
}