# Implementation Plan - Catalog Feature Testing & Debugging

This plan outlines the steps to implement comprehensive testing (unit, widget, integration) for the `catalog` feature and resolve the issue where categories are not displayed on the screen.

## 1. Investigation & Setup
- [ ] Verify the content of the `group_products` and `main_products` tables in the database (via code analysis/mocking).
- [ ] Confirm if `CatalogCubit` should be fetching `group` or `main` categories for the initial load.
- [ ] Create the necessary test directory structure: `test/features/catalog/data`, `test/features/catalog/domain`, `test/features/catalog/presentation`.

## 2. Unit Testing
- [ ] **Data Layer**:
    - [ ] `CategoryModel`: Test `fromJson` and `toEntity` for different category types.
    - [ ] `CatalogRemoteDataSource`: Mock `SupabaseClient` and test `getCategories`, `getProducts`, etc.
    - [ ] `CatalogRepository`: Test the repository logic, including caching and error handling.
- [ ] **Domain Layer**:
    - [ ] `GetCategoriesUseCase`: Test with different parameters.
- [ ] **Presentation Layer**:
    - [ ] `CatalogCubit`: Use `bloc_test` to verify states (`CatalogInitial`, `CatalogLoading`, `CatalogLoaded`, `CatalogError`).

## 3. Widget Testing
- [ ] **CategoriesPage**:
    - [ ] Test that `AppShimmer` (Loading widget) shows up initially.
    - [ ] Test that `AppErrorWidget` shows up on failure.
    - [ ] Test that `_LoadedWidget` (GridView) renders the correct number of category items.
    - [ ] **Debug**: Identify why categories might not be appearing (e.g., check if `groups` list is empty or if widgets are being clipped).

## 4. Integration Testing
- [ ] Create `integration_test/catalog_flow_test.dart`.
- [ ] Test the flow: Open App -> Navigate to Categories -> Verify categories are visible and tappable.

## 5. Bug Fix (If identified)
- [ ] If `CatalogCubit` is fetching the wrong category type, update it.
- [ ] Ensure `CategoryModel` correctly handles all table schemas if they differ.

## 6. Verification
- [ ] Run all tests using `flutter test`.
- [ ] Run integration tests on an emulator/device.
