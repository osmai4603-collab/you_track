import '../entities/custom_field.dart';
import '../entities/field_type.dart';

abstract class CustomFieldRepository {
  /// Creates a new custom field in the specified project.
  /// Throws [ValidationException] if validation fails.
  /// Throws [NetworkException] if network error occurs.
  Future<CustomField> createCustomField({
    required String projectId,
    required String name,
    String? description,
    required FieldType type,
    bool isPrivate = false,
  });

  /// Gets all custom fields for a project.
  /// Returns empty list if no fields exist.
  Future<List<CustomField>> getCustomFieldsByProject(String projectId);

  /// Validates that field name is unique within project.
  /// Returns true if name is available, false if taken.
  Future<bool> validateFieldNameUniqueness({
    required String projectId,
    required String name,
  });

  /// Updates an existing custom field.
  /// Throws [ValidationException] if validation fails.
  /// Throws [NotFoundException] if field doesn't exist.
  Future<CustomField> updateCustomField({
    required String fieldId,
    String? name,
    String? description,
    FieldType? type,
    bool? isPrivate,
  });

  /// Soft deletes a custom field.
  /// Throws [NotFoundException] if field doesn't exist.
  Future<void> deleteCustomField(String fieldId);
}