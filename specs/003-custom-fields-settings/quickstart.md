# Quickstart: Custom Fields Settings

## Prerequisites

- Flutter SDK 3.x
- Supabase local instance running (or access to a Supabase project)
- Existing project with authentication and project module working
- `reorderables` package added to `pubspec.yaml`

## Setup

### 1. Run Supabase Migration

```bash
supabase migration new create_custom_fields
```

Copy the SQL from [data-model.md](data-model.md#supabase-tables) into the migration file, then:

```bash
supabase db push
```

### 2. Add Dependencies

```bash
flutter pub add reorderables
```

### 3. Generate Code (if using json_serializable or freezed)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Register Dependency Injection

Add to the service locator setup (e.g., `lib/core/init_dependencies.dart`):

```dart
// Data sources
sl.registerLazySingleton<CustomFieldsRemoteDataSource>(
  () => CustomFieldsRemoteDataSourceImpl(sl<SupabaseClient>()),
);

// Repository
sl.registerLazySingleton<CustomFieldsRepository>(
  () => CustomFieldsRepositoryImpl(sl<CustomFieldsRemoteDataSource>()),
);

// Use cases
sl.registerLazySingleton(() => GetCustomFieldsUseCase(sl()));
sl.registerLazySingleton(() => AddCustomFieldUseCase(sl()));
sl.registerLazySingleton(() => UpdateCustomFieldUseCase(sl()));
sl.registerLazySingleton(() => DeleteCustomFieldsUseCase(sl()));
sl.registerLazySingleton(() => ReorderCustomFieldsUseCase(sl()));

// Cubit
sl.registerFactory(() => CustomFieldsCubit(
  sl<GetCustomFieldsUseCase>(),
  sl<AddCustomFieldUseCase>(),
  sl<UpdateCustomFieldUseCase>(),
  sl<DeleteCustomFieldsUseCase>(),
  sl<ReorderCustomFieldsUseCase>(),
));
```

### 5. Wire the UI

Replace the placeholder in `navigation_service.dart` (line 293-296):

```dart
// BEFORE:
child: const Center(child: Text('Custom Fields Settings')),

// AFTER:
child: const CustomFieldsSettingsSection(),
```

## Validation Scenarios

### Scenario A: View Custom Fields Table

1. Navigate to a project → Settings → Custom Fields
2. **Expected**: Table displays with columns: checkbox, drag handle, name, type, default value
3. If no fields exist: empty state with "Add Field" button is shown

### Scenario B: Add a Custom Field

1. Press "Add Field" button
2. Enter name: "Priority"
3. Select type: "priority"
4. Select default value: "normal"
5. Press Save
6. **Expected**: New row appears in table with name "Priority", type "priority", default "normal"

### Scenario C: Reorder Fields via Drag-and-Drop

1. Long-press the drag handle on a field row
2. Drag the row to a new position
3. Release
4. **Expected**: Field order updates in the table and persists after page refresh

### Scenario D: Delete a Custom Field

1. Check the checkbox next to a field
2. Press "Delete" button
3. Confirm deletion in the dialog
4. **Expected**: Field is removed from the table; associated issue data is preserved

### Scenario E: Field Name Validation

1. Press "Add Field" with empty name
2. **Expected**: Error message "Field name is required"
3. Add a field with name "Priority"
4. Try to add another field with name "Priority"
5. **Expected**: Error message "Field name already exists"

## Running Tests

```bash
# Run all tests
flutter test

# Run only custom fields tests
flutter test test/features/custom_fields/

# Run with coverage
flutter test --coverage
```

## Expected Outcomes

- All CRUD operations complete successfully against Supabase
- Drag-and-drop reordering persists across page reloads
- Field validations (empty name, duplicate name) show appropriate error messages
- Sidebar navigation correctly highlights "Custom Fields" when on the section
