# Contracts: Tags Repository Interface

**Feature**: 010-new-tag-dialog
**Date**: 2026-07-26

## TagsRepository Interface

The repository defines the contract between presentation and data layers.

```dart
abstract class TagsRepository {
  /// Creates a new tag and returns the created Tag entity.
  /// Throws [TagCreationFailure] if name is empty, exceeds 100 chars,
  /// or is not unique within the project.
  Future<Either<Failure, Tag>> createTag({
    required String name,
    required String projectId,
    required String ownerId,
    required bool shared,
    required bool removeOnResolution,
    required bool favorite,
    required Map<String, TagPermissionScope> permissions,
    List<String>? specificUserIds,
    required List<TagSubscriptionEvent> subscriptions,
  });

  /// Associates a tag with an issue.
  Future<Either<Failure, void>> associateTagWithIssue({
    required String issueId,
    required String tagId,
  });

  /// Fetches project members for the Owner dropdown.
  Future<Either<Failure, List<ProjectMember>>> getProjectMembers({
    required String projectId,
  });

  /// Validates tag name uniqueness within a project.
  Future<Either<Failure, bool>> isTagNameUnique({
    required String name,
    required String projectId,
  });
}
```

## Data Flow

```
User Input → NewTagCubit → CreateTag UseCase → TagsRepository → TagRemoteDatasource → Supabase
```

## Error Types

| Error | Condition | User Message |
|-------|-----------|--------------|
| EmptyNameError | name.trim().isEmpty | "Tag name is required" |
| NameTooLongError | name.length > 100 | "Tag name must be 100 characters or less" |
| DuplicateNameError | name already exists in project | "A tag with this name already exists" |
| NetworkError | Supabase request fails | "Unable to create tag. Check your connection." |
| UnknownError | Unexpected failure | "Something went wrong. Please try again." |
