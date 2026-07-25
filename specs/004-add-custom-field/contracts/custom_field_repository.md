# Contract: CustomFieldRepository Interface

## Purpose
Define the contract for custom field data operations, ensuring clean separation between domain and data layers.

## Interface Definition

```dart
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
```

## Data Transfer Objects

### CustomFieldDTO
```dart
class CustomFieldDTO {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String type;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor, fromJson, toJson methods
}
```

## Error Handling

### Exception Types
- `ValidationException`: Invalid input data
- `NotFoundException`: Requested resource not found
- `NetworkException`: Network connectivity issues
- `PermissionException`: Insufficient permissions

### Error Response Format
```dart
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});
}
```

## Testing Contract

### Unit Tests
- Test each repository method with mock data source
- Test validation logic with valid/invalid inputs
- Test error handling for each exception type

### Integration Tests
- Test repository with real Supabase client (local instance)
- Test RLS policies with different user roles
- Test network error handling

## Mock Requirements

### Mock Data Source
- Mock Supabase client responses
- Simulate network delays and errors
- Provide test data fixtures

### Mock Behaviors
- Success responses with test data
- Validation error responses
- Network error responses
- Permission error responses