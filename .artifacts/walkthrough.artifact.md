# Walkthrough - Fetching Project Members with Projects

I have updated the project fetching logic to include project members and their associated user information (names, emails, and avatars) in a single query.

## Changes Made

### Project Domain & Data Layers

#### [ProjectEntity](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/domain/entities/project_entity.dart)
- Added `members` field to hold a list of `ProjectMemberEntity`.
- Updated `copyWith` and `props` to support the new field.

#### [ProjectMemberModel](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/models/project_member_model.dart)
- Updated `fromJson` and `fromMap` to extract data from the nested `users` object returned by Supabase.
- Mapped `full_name` to `name`, `email` to `email`, and `avatar_url` to `avatarUrl`.
- Ensured `id` correctly uses `user_id` when present.

#### [ProjectModel](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/models/project_model.dart)
- Updated to handle the parsing of `project_members` from JSON/Map into `ProjectMemberModel` objects.
- Updated `toJson` and `toMap` to include members in the serialized output.

#### [ProjectsRemoteDataSourceImpl](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/datasources/projects_remote_data_source.dart)
- Modified `getProjects()` and `getProjectById()` to use a relational select query:
  ```dart
  .select('*, project_members(*, users(*))')
  ```
- This fetches all projects, their members, and the corresponding user profile data in one go.

## Verification Results

### Manual Verification
- The `ProjectsRemoteDataSource` now retrieves projects with the `members` list populated.
- Each member contains the user's name and email extracted from the joined `users` table.
