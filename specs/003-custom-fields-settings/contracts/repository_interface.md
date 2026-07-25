# Repository Interface: CustomFieldsRepository

**Location**: `lib/features/custom_fields/domain/repositories/custom_fields_repository.dart`

## Contract

```dart
abstract class CustomFieldsRepository {
  /// Get all custom fields for a project, ordered by [orderIndex].
  Future<List<CustomFieldEntity>> getFields(String projectId);

  /// Add a new custom field to a project.
  /// Throws [NameAlreadyExistsException] if name is not unique within the project.
  Future<CustomFieldEntity> addField({
    required String projectId,
    required String name,
    required CustomFieldType fieldType,
    String? defaultValue,
  });

  /// Update an existing custom field.
  /// Throws [CustomFieldNotFoundException] if field doesn't exist.
  /// Throws [NameAlreadyExistsException] if new name conflicts.
  Future<CustomFieldEntity> updateField({
    required String fieldId,
    String? name,
    CustomFieldType? fieldType,
    String? defaultValue,
  });

  /// Delete one or more custom fields by their IDs.
  /// Field data in existing issues is preserved (orphaned via DELETE RESTRICT).
  Future<void> deleteFields(List<String> fieldIds);

  /// Reorder a field from [oldIndex] to [newIndex].
  /// Updates [orderIndex] for affected fields.
  Future<void> reorderField({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  });
}
```

## Data Source Interface

**Location**: `lib/features/custom_fields/data/datasources/custom_fields_remote_data_source.dart`

```dart
abstract class CustomFieldsRemoteDataSource {
  Future<List<CustomFieldModel>> getFields(String projectId);
  Future<CustomFieldModel> addField(CustomFieldModel field);
  Future<CustomFieldModel> updateField(CustomFieldModel field);
  Future<void> deleteFields(List<String> fieldIds);
  Future<void> reorderFields(String projectId, List<Map<String, dynamic>> orderUpdates);
}
```

## Cubit Interface

**Location**: `lib/features/custom_fields/presentation/cubits/custom_fields_cubit.dart`

```dart
sealed class CustomFieldsState {
  const CustomFieldsState();
}

final class CustomFieldsInitial extends CustomFieldsState {
  const CustomFieldsInitial();
}

final class CustomFieldsLoading extends CustomFieldsState {
  const CustomFieldsLoading();
}

final class CustomFieldsLoaded extends CustomFieldsState {
  final List<CustomFieldEntity> fields;
  final bool isSaving;
  const CustomFieldsLoaded({required this.fields, this.isSaving = false});
}

final class CustomFieldsError extends CustomFieldsState {
  final String message;
  const CustomFieldsError(this.message);
}
```

## Use Case Contracts

**Location**: `lib/features/custom_fields/domain/usecases/`

```dart
// get_custom_fields_use_case.dart
class GetCustomFieldsUseCase {
  Future<List<CustomFieldEntity>> call(String projectId);
}

// add_custom_field_use_case.dart
class AddCustomFieldUseCase {
  Future<CustomFieldEntity> call({
    required String projectId,
    required String name,
    required CustomFieldType fieldType,
    String? defaultValue,
  });
}

// update_custom_field_use_case.dart
class UpdateCustomFieldUseCase {
  Future<CustomFieldEntity> call({
    required String fieldId,
    String? name,
    CustomFieldType? fieldType,
    String? defaultValue,
  });
}

// delete_custom_fields_use_case.dart
class DeleteCustomFieldsUseCase {
  Future<void> call(List<String> fieldIds);
}

// reorder_custom_fields_use_case.dart
class ReorderCustomFieldsUseCase {
  Future<void> call({
    required String projectId,
    required int oldIndex,
    required int newIndex,
  });
}
```
