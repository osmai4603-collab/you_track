# Implementation Plan: New Tag Dialog

Review of the `@010-new-tag-dialog` spec reveals that the feature implementation has not yet started. I will proceed with implementing the feature following the established Clean Architecture and Cubit patterns.

## User Review Required

> [!IMPORTANT]
> The implementation involves creating several new database-backed entities (`Tag`, `TagPermission`, `TagSubscription`) and integrating them with Supabase. Ensure the Supabase schema is ready as per `specs/010-new-tag-dialog/data-model.md`.

## Proposed Changes

The implementation will be executed in phases as defined in the project's task list.

---

### Phase 1: Shared Infrastructure
Creation of enums, base entities, and shared widgets.

#### [NEW] [tag_permission_scope_enum.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/enums/tag_permission_scope_enum.dart)
#### [NEW] [tag_permission_type_enum.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/enums/tag_permission_type_enum.dart)
#### [NEW] [tag_subscription_event_enum.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/enums/tag_subscription_event_enum.dart)
#### [NEW] [tag.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/tag.dart)
#### [NEW] [tag_permission.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/tag_permission.dart)
#### [NEW] [tag_subscription.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/tag_subscription.dart)
#### [NEW] [project_member.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/project_member.dart)
#### [NEW] [skeleton_shimmer.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/widgets/skeleton_shimmer.dart)

---

### Phase 2: Foundational Layer
Data sources, repositories, and use cases.

#### [NEW] [tags_repository.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/repositories/tags_repository.dart)
#### [NEW] [tag_model.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/tag_model.dart)
#### [NEW] [tag_remote_datasource.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/datasources/tag_remote_datasource.dart)
#### [NEW] [tags_repository_impl.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/repositories/tags_repository_impl.dart)
#### [NEW] [create_tag.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/create_tag.dart)
#### [NEW] [get_project_members.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/get_project_members.dart)
#### [NEW] [is_tag_name_unique.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/is_tag_name_unique.dart)
#### [NEW] [associate_tag_with_issue.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/associate_tag_with_issue.dart)
#### [MODIFY] [init_dependencies.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/init_dependencies.dart)

---

### Phase 3-6: Presentation Layer
Cubit, Dialog, and integration.

#### [NEW] [new_tag_state.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/new_tag_state.dart)
#### [NEW] [new_tag_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/new_tag_cubit.dart)
#### [NEW] [new_tag_dialog.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/new_tag_dialog.dart)
#### [NEW] [new_tag_form.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/new_tag_form.dart)
#### [NEW] [tag_permissions_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/tag_permissions_section.dart)
#### [NEW] [tag_subscriptions_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/tag_subscriptions_section.dart)
#### [NEW] [specific_users_picker.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/specific_users_picker.dart)
#### [MODIFY] [issue_form_sidebar.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/issue_form_sidebar.dart)

---

## Verification Plan

### Automated Tests
- Unit tests for `NewTagCubit` and use cases.
- Widget tests for `NewTagDialog`.
- Run: `flutter test test/features/issues/`

### Manual Verification
- Trigger the "New Tag" dialog from the issue sidebar.
- Create tags with various settings and verify they are correctly saved in Supabase and associated with the issue.
- Verify validation logic for empty and duplicate names.
