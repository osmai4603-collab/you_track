# Fix Type Mismatch Error in Projects List

The user reported a `type 'List<dynamic>' is not a subtype of type 'List<ProjectMemberEntity>'` error in `projects_list_page.dart`. This is caused by improper casting during JSON deserialization in `ProjectModel`.

## Proposed Changes

### Projects Feature

#### [MODIFY] [project_model.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/models/project_model.dart)

I will update `ProjectModel.fromMap` and `ProjectModel.fromJson` to explicitly handle the list mapping and ensure the result is a typed `List<ProjectMemberEntity>`.

Changes include:
- Casting the raw list to `List?` before mapping.
- Using `.map<ProjectMemberModel>(...)` to ensure the resulting iterable is typed.
- Converting to list which will then be `List<ProjectMemberModel>`, a subtype of `List<ProjectMemberEntity>`.

## Verification Plan

### Manual Verification
- The user should run the app and navigate to the Projects list page. The error should no longer appear, and the member avatars should be displayed correctly.
