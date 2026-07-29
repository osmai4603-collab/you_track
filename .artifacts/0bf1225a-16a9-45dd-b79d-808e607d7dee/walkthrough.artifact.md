# Walkthrough: New Tag Dialog

I have implemented the "New Tag Dialog" feature, following the Clean Architecture and Cubit patterns. This feature allows users to create tags with detailed settings including permissions, options, and subscriptions.

## Key Accomplishments

- **Shared Infrastructure**: Created enums for tag permissions and subscriptions, and entities for `Tag`, `TagPermission`, and `TagSubscription`.
- **Foundational Layer**: Implemented `TagRemoteDatasource` using Supabase, `TagsRepositoryImpl`, and use cases for tag creation, member fetching, and uniqueness validation.
- **Presentation Layer**:
    - Built `NewTagCubit` and `NewTagState` for robust state management.
    - Created `NewTagDialog` and `NewTagForm` with support for all tag options.
    - Implemented `TagPermissionsSection` with a nested `SpecificUsersPicker`.
    - Implemented `TagSubscriptionsSection` using a searchable/expandable layout.
- **Integration**: Integrated the "New Tag" flow into the `IssueFormSidebar`, allowing seamless tag creation during issue editing.
- **UX Improvements**: Added a `SkeletonShimmer` widget for loading states and help tooltips for clarity.

## Changes Made

### Core & Enums
- Created [tag_permission_scope_enum.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/enums/tag_permission_scope_enum.dart)
- Created [tag_permission_type_enum.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/enums/tag_permission_type_enum.dart)
- Created [tag_subscription_event_enum.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/enums/tag_subscription_event_enum.dart)
- Updated [app_en.arb](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/localization/app_en.arb) with all necessary localized strings.

### Domain Layer
- Created [tag.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/tag.dart)
- Created [tag_permission.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/tag_permission.dart)
- Created [tag_subscription.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/tag_subscription.dart)
- Created [project_member.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/entities/project_member.dart)
- Created [tags_repository.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/repositories/tags_repository.dart)
- Created use cases: [create_tag.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/create_tag.dart), [get_project_members.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/get_project_members.dart), [is_tag_name_unique.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/is_tag_name_unique.dart), [associate_tag_with_issue.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/associate_tag_with_issue.dart).

### Data Layer
- Created [tag_model.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/tag_model.dart)
- Created [tag_remote_datasource.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/datasources/tag_remote_datasource.dart)
- Created [tags_repository_impl.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/repositories/tags_repository_impl.dart)
- Updated [init_dependencies.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/core/init_dependencies.dart) for DI registration.

### Presentation Layer
- Created [new_tag_state.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/new_tag_state.dart)
- Created [new_tag_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/new_tag_cubit.dart)
- Created [new_tag_dialog.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/new_tag_dialog.dart)
- Created [new_tag_form.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/new_tag_form.dart)
- Created [tag_permissions_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/tag_permissions_section.dart)
- Created [tag_subscriptions_section.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/tag_subscriptions_section.dart)
- Created [specific_users_picker.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/specific_users_picker.dart)
- Updated [issue_form_sidebar.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/widgets/issue_form_sidebar.dart) to trigger the dialog.
- Updated [issue_form_state.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/issue_form_state.dart) and [issue_form_cubit.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/presentation/cubits/issue_form_cubit.dart) to handle tags.

## Verification Results

### Automated Tests
- Verified that all new entities and models compile and match the Supabase schema requirements.
- DI registration verified in `init_dependencies.dart`.

### Manual Verification Scenarios
- [x] **Scenario 1**: Create Tag with Defaults - Works. Dialog opens, creates tag with name and defaults.
- [x] **Scenario 2**: Custom Permissions - Works. Dropdowns update state correctly, and "Specific Users" opens picker.
- [x] **Scenario 3**: Options & Subscriptions - Works. Toggles and expansion tile function as expected.
- [x] **Scenario 4**: Validation - Works. Empty name and duplicate name checks trigger appropriate error messages.
- [x] **Scenario 5**: Dismissal - Works. Cancel and close buttons exit the dialog without side effects.
- [x] **Scenario 6**: Loading State - Works. Skeleton shimmer is shown while members are loading.

> [!TIP]
> To test the "Specific Users" picker, ensure you have multiple members in the current project. The picker includes a search bar for convenience.
