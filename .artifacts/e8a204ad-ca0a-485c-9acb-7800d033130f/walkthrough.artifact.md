# Walkthrough - Fixing `GroupsSqliteDataSourceImpl.getGroups` Override

I have updated the `GroupsSqliteDataSourceImpl.getGroups` method to correctly override the `GroupsRemoteDataSource.getGroups` interface method by adding the missing `userId` parameter and implementing the corresponding filtering logic.

## Changes Made

### Data Sources

#### [GroupsSqliteDataSourceImpl](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/datasources/groups_sqlite_data_source_impl.dart)

- Updated `getGroups` signature to include `userId` as an optional named parameter.
- Modified the implementation to filter groups by `userId` if provided:
    - First, it queries the `group_members` table to find all `group_id`s associated with the given `userId`.
    - Then, it fetches group details from the `groups` table only for those `group_id`s.
    - If `userId` is null, it continues to fetch all groups as before.

```diff
   @override
-  Future<List<GroupModel>> getGroups() async {
-    final rows = _sqlite.query(
-      table: _groupsTable.tableName,
-      orderBy: 'created_at DESC',
-    );
+  Future<List<GroupModel>> getGroups({String? userId}) async {
+    List<Map<String, dynamic>> rows;
+
+    if (userId != null) {
+      final memberRows = _sqlite.query(
+        table: _membersTable.tableName,
+        where: '${_membersTable.userId} = ?',
+        whereArgs: [userId],
+      );
+      final groupIds = memberRows
+          .map((e) => e[_membersTable.groupId].toString())
+          .toList();
+
+      if (groupIds.isEmpty) {
+        return [];
+      }
+
+      final whereClause = groupIds.map((_) => '?').join(', ');
+      rows = _sqlite.query(
+        table: _groupsTable.tableName,
+        where: '${_groupsTable.id} IN ($whereClause)',
+        whereArgs: groupIds,
+        orderBy: 'created_at DESC',
+      );
+    } else {
+      rows = _sqlite.query(
+        table: _groupsTable.tableName,
+        orderBy: 'created_at DESC',
+      );
+    }
+
     for (final row in rows) {
```

## Verification Results

### Automated Tests
- Ran `analyze_file` on `groups_sqlite_data_source_impl.dart`, which returned no errors. This confirms that the signature now correctly overrides the base class and that the new logic is syntactically valid.
