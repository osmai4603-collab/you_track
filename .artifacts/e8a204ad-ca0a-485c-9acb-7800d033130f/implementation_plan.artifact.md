# Fix invalid override in `GroupsSqliteDataSourceImpl`

The `GroupsSqliteDataSourceImpl.getGroups` method does not match the signature defined in the `GroupsRemoteDataSource` interface. Specifically, it is missing the optional named parameter `userId`.

## Proposed Changes

### [groups_sqlite_data_source_impl.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/datasources/groups_sqlite_data_source_impl.dart)

#### [MODIFY] [GroupsSqliteDataSourceImpl](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/datasources/groups_sqlite_data_source_impl.dart)

- Update `getGroups` signature to `Future<List<GroupModel>> getGroups({String? userId})`.
- Implement filtering by `userId` if it's provided. This will involve:
    1. Querying `group_members` table for the given `userId` to get the list of `group_id`s.
    2. Querying `groups` table for those `group_id`s.
    3. If `userId` is null, continue fetching all groups as before.

## Verification Plan

### Automated Tests
- I will check if the file compiles (no static analysis errors) after the change.
- Since I don't have a test runner easily available in this environment, I'll rely on the fact that the signature will match the interface.

### Manual Verification
- Verify that the error message reported by the user is resolved.
