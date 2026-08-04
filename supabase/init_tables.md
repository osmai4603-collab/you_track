## Table `users`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `email` | `text` |  Unique |
| `user_name` | `text` |  Nullable |
| `avatar_url` | `text` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `full_name` | `text` |  Nullable |
| `timezone` | `text` |  |

## Table `projects`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `text` |  Unique |
| `name` | `text` |  |
| `description` | `text` |  Nullable |
| `owner_id` | `uuid` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `is_archived` | `bool` |  |
| `template_type` | `text` |  Nullable |
| `is_favorite` | `bool` |  |
| `starting_number` | `int4` |  Nullable |
| `visibility` | `uuid` |  Nullable |
| `recommended_visibility` | `_uuid` |  Nullable |
| `has_time_tracking` | `bool` |  |
| `estimation` | `int8` |  Nullable |
| `spent_time` | `int8` |  Nullable |
| `key` | `text` |  Nullable |

## Table `project_members`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `project_id` | `uuid` |  |
| `user_id` | `uuid` |  |
| `role` | `text` |  |
| `is_owner` | `bool` |  Nullable |
| `id` | `uuid` | Primary |

## Table `issues`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `uuid` |  |
| `issue_sequence` | `int4` |  |
| `issue_key` | `text` |  Unique |
| `description` | `text` |  Nullable |
| `reporter_id` | `uuid` |  Nullable |
| `assignee_id` | `uuid` |  Nullable |
| `state` | `text` |  Nullable |
| `priority` | `text` |  Nullable |
| `issue_type` | `text` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `updated_at` | `timestamptz` |  Nullable |
| `summary` | `text` |  |
| `due_date` | `timestamptz` |  Nullable |
| `estimation` | `int4` |  Nullable |
| `spent_time` | `int4` |  Nullable |
| `votes` | `int4` |  Nullable |
| `watchers_count` | `int4` |  Nullable |
| `attachments_count` | `int4` |  Nullable |
| `comments_count` | `int4` |  Nullable |
| `is_starred` | `bool` |  Nullable |
| `parent_id` | `uuid` |  Nullable |
| `subsystem_id` | `uuid` |  |
| `fix_versions` | `text` |  |
| `fixed_in_build` | `text` |  |
| `build_id` | `uuid` |  Nullable |
| `visibility` | `jsonb` |  Nullable |

## Table `comments`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `issue_id` | `uuid` |  |
| `user_id` | `uuid` |  |
| `content` | `text` |  |
| `created_at` | `timestamptz` |  Nullable |
| `updated_at` | `timestamptz` |  Nullable |

## Table `attachments`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `issue_id` | `uuid` |  |
| `user_id` | `uuid` |  |
| `file_url` | `text` |  |
| `file_name` | `text` |  |
| `file_type` | `text` |  Nullable |
| `file_size` | `int4` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |

## Table `issue_links`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `source_issue_id` | `uuid` |  |
| `target_issue_id` | `uuid` |  |
| `link_type` | `text` |  |

## Table `notifications`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `user_id` | `uuid` |  |
| `title` | `text` |  |
| `content` | `text` |  Nullable |
| `related_issue_id` | `uuid` |  Nullable |
| `is_read` | `bool` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |

## Table `dashboards`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  |
| `owner_id` | `uuid` |  |
| `is_default` | `bool` |  Nullable |
| `is_favorite` | `bool` |  Nullable |
| `layout_config` | `jsonb` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `updated_at` | `timestamptz` |  Nullable |

## Table `dashboard_widgets`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `dashboard_id` | `uuid` |  |
| `widget_type` | `text` |  |
| `title` | `text` |  |
| `config` | `jsonb` |  Nullable |
| `position_x` | `int4` |  Nullable |
| `position_y` | `int4` |  Nullable |
| `width` | `int4` |  Nullable |
| `height` | `int4` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `updated_at` | `timestamptz` |  Nullable |

## Table `dashboard_shares`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `dashboard_id` | `uuid` | Primary |
| `user_id` | `uuid` | Primary |
| `permission` | `text` |  |

## Table `custom_fields`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `uuid` |  |
| `name` | `text` |  |
| `field_type` | `text` |  |
| `field_mode` | `text` |  |
| `value_mode` | `text` |  |
| `default_value` | `text` |  Nullable |
| `empty_value` | `text` |  Nullable |
| `can_be_empty` | `bool` |  |
| `aliases` | `_text` |  Nullable |
| `visible_to` | `_uuid` |  Nullable |
| `updatable_by` | `_uuid` |  Nullable |
| `show_only_when` | `uuid` |  Nullable |
| `filter_values_based_on` | `uuid` |  Nullable |
| `order_index` | `int4` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `visibility` | `text` |  |
| `access_control` | `jsonb` |  |

## Table `articles`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `uuid` |  |
| `parent_id` | `uuid` |  Nullable |
| `title` | `text` |  |
| `content_markdown` | `text` |  |
| `status` | `text` |  |
| `visibility` | `_text` |  |
| `sort_order` | `int4` |  |
| `created_by` | `uuid` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `article_comments`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `article_id` | `uuid` |  |
| `author_id` | `uuid` |  |
| `comment_text` | `text` |  |
| `anchor_text` | `text` |  |
| `anchor_start` | `int4` |  |
| `anchor_end` | `int4` |  |
| `is_resolved` | `bool` |  |
| `resolved_by` | `uuid` |  Nullable |
| `resolved_at` | `timestamptz` |  Nullable |
| `created_at` | `timestamptz` |  |

## Table `article_notifications`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `recipient_id` | `uuid` |  |
| `sender_id` | `uuid` |  |
| `article_id` | `uuid` |  |
| `comment_id` | `uuid` |  Nullable |
| `notification_type` | `text` |  |
| `is_read` | `bool` |  |
| `created_at` | `timestamptz` |  |

## Table `sprints`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  |
| `start_date` | `timestamptz` |  Nullable |
| `release_date` | `timestamptz` |  Nullable |
| `is_released` | `bool` |  Nullable |
| `description` | `text` |  Nullable |
| `color` | `int4` |  Nullable |
| `project_id` | `uuid` |  Nullable |

## Table `issue_sprints`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `issue_id` | `uuid` | Primary |
| `sprint_id` | `uuid` | Primary |

## Table `tags`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  |
| `owner_id` | `uuid` |  Nullable |
| `project_id` | `uuid` |  Nullable |
| `shared` | `bool` |  Nullable |
| `remove_on_resolution` | `bool` |  Nullable |
| `favorite` | `bool` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `created_by` | `uuid` |  Nullable |

## Table `tag_permissions`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `tag_id` | `uuid` |  Nullable |
| `permission_type` | `text` |  |
| `scope` | `text` |  |
| `user_ids` | `_uuid` |  Nullable |

## Table `tag_subscriptions`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `tag_id` | `uuid` |  Nullable |
| `event_type` | `text` |  |

## Table `issue_tags`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `issue_id` | `uuid` | Primary |
| `tag_id` | `uuid` | Primary |

## Table `fixed_in_builds`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `text` | Primary |
| `name` | `text` |  |
| `date` | `timestamptz` |  |
| `projectId` | `uuid` |  |

## Table `builds`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  |
| `date` | `timestamptz` |  Nullable |
| `project_id` | `uuid` |  |

## Table `vcs_integrations`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `uuid` |  |
| `integration_name` | `text` |  |
| `provider_type` | `vcs_provider_type` |  |
| `server_url` | `text` |  Nullable |
| `auth_mode` | `vcs_auth_mode` |  |
| `encrypted_token` | `text` |  Nullable |
| `ssh_private_key` | `text` |  Nullable |
| `passphrase` | `text` |  Nullable |
| `organization_owner` | `text` |  |
| `repository_name` | `text` |  |
| `branch_specification` | `text` |  |
| `parse_commits_for_commands` | `bool` |  |
| `silent_processing` | `bool` |  |
| `pull_request_automation` | `bool` |  |
| `command_executors_groups` | `_uuid` |  Nullable |
| `visible_to_roles` | `_uuid` |  |
| `automatic_user_mapping` | `bool` |  |
| `status` | `vcs_connection_status` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `vcs_user_mappings`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `integration_id` | `uuid` |  |
| `vcs_username_or_email` | `text` |  |
| `youtrack_user_id` | `uuid` |  |
| `created_at` | `timestamptz` |  |

## Table `vcs_commits`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `integration_id` | `uuid` |  |
| `task_id` | `uuid` |  |
| `commit_sha` | `text` |  |
| `author_name` | `text` |  |
| `author_email` | `text` |  |
| `message` | `text` |  |
| `branch` | `text` |  |
| `committed_at` | `timestamptz` |  |
| `processed_at` | `timestamptz` |  |

## Table `vcs_pull_requests`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `integration_id` | `uuid` |  |
| `task_id` | `uuid` |  |
| `pr_number` | `int4` |  |
| `title` | `text` |  |
| `author_name` | `text` |  |
| `source_branch` | `text` |  |
| `target_branch` | `text` |  |
| `state` | `vcs_pr_state` |  |
| `opened_at` | `timestamptz` |  |
| `merged_at` | `timestamptz` |  Nullable |
| `closed_at` | `timestamptz` |  Nullable |
| `created_at` | `timestamptz` |  |

## Table `roles`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `name` | `text` | Primary |
| `permissions` | `_text` |  |
| `description` | `text` |  Nullable |

## Table `groups`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  |
| `description` | `text` |  Nullable |
| `logo` | `text` |  Nullable |
| `auto_join` | `bool` |  |
| `auto_join_domains` | `text` |  Nullable |
| `two_factor_auth` | `text` |  |
| `visible_to` | `jsonb` |  Nullable |
| `updatable_by` | `text` |  |
| `group_type` | `text` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `avatar_url` | `text` |  Nullable |

## Table `group_roles`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `role_name` | `text` |  |
| `group_id` | `uuid` |  |
| `project_id` | `uuid` |  |

## Table `group_members`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `user_id` | `uuid` |  |
| `group_id` | `uuid` |  |

## Table `group_projects`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `group_id` | `uuid` |  |
| `project_id` | `uuid` |  |

## Table `time_tracking_configs`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `uuid` |  Unique |
| `enabled` | `bool` |  |
| `estimation_field_id` | `uuid` |  Nullable |
| `spent_time_field_id` | `uuid` |  Nullable |
| `aggregate_spent_time` | `bool` |  |
| `aggregate_estimation` | `bool` |  |
| `updated_at` | `timestamptz` |  |

## Table `work_item_attributes`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `project_id` | `uuid` |  |
| `name` | `text` |  |
| `is_active` | `bool` |  |
| `sort_order` | `int4` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `attribute_values`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `value` | `text` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `attribute_id` | `uuid` |  |
| `color` | `int8` |  |
| `first_letter` | `text` |  |

## Table `issue_subsystems`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `created_at` | `timestamptz` |  |
| `project_id` | `uuid` |  |
| `name` | `text` |  |
| `owner_id` | `uuid` |  |
| `color` | `int8` |  |
| `first_letter` | `text` |  |

## Table `user_preferences`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `user_id` | `uuid` |  Unique |
| `theme` | `text` |  |
| `links_panel_position` | `text` |  |
| `show_recent_issues` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `user_notification_settings`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `user_id` | `uuid` |  Unique |
| `email_enabled` | `bool` |  |
| `email_format` | `text` |  |
| `telegram_enabled` | `bool` |  |
| `telegram_connected` | `bool` |  |
| `notify_changes_by_me` | `bool` |  |
| `notify_mentions` | `bool` |  |
| `notify_duplicate_changes` | `bool` |  |
| `notify_email_created` | `bool` |  |
| `notify_vcs_updates` | `bool` |  |
| `notify_vcs_failed_commands` | `bool` |  |
| `star_on_comment` | `bool` |  |
| `star_on_create` | `bool` |  |
| `star_on_update` | `bool` |  |
| `star_on_assigned` | `bool` |  |
| `star_on_vote` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `saved_searches`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `user_id` | `uuid` |  |
| `name` | `text` |  |
| `query` | `text` |  |
| `is_favorite` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Custom Types / Enums

### `vcs_provider_type`

`github` | `gitlab` | `bitbucket_cloud` | `bitbucket_server` | `gitea` | `custom_git`

### `vcs_auth_mode`

`oauth` | `token` | `ssh`

### `vcs_connection_status`

`connected` | `disabled` | `auth_failed` | `sync_error`

### `vcs_pr_state`

`open` | `merged` | `closed`

### `issue_state`

`to-do` | `in-progress` | `done`

### `issue_priority`

`show-stopper` | `critical` | `major` | `normal` | `minor`

### `issue_type`

`bug` | `cosmetic` | `exception` | `feature` | `task` | `usability-problem` | `performance-problem` | `epic`

### `issue_subsystem`

`no-value` | `issue-tracking` | `project-management` | `migration`

### `issue_link_type`

`relates-to` | `is-required-for` | `depends-on` | `is-duplicated-by` | `duplicates` | `parent-for` | `subtask-of`

### `user_role`

`contributor` | `project-admin` | `system-admin`

### `article_status`

`draft` | `published`

### `tag_permission_scope`

`owner` | `admin` | `developer` | `viewer` | `all_members` | `specific_users`

### `tag_permission_type`

`view` | `use` | `edit`

### `tag_subscription_event`

`updates` | `comments` | `tag_added` | `spent_time` | `issue_resolved` | `votes` | `tag_removed`

### `custom_field_type`

`build` | `enum` | `group` | `owned-field` | `state` | `user` | `version` | `date` | `date-time` | `float` | `integer` | `string` | `text` | `period`

### `project_widget_type`

`document-list-widget` | `issue-list` | `issue-distribution-report` | `calendar-widget` | `issue-activity-feed` | `project-team` | `access-eraser` | `quick-notes` | `report` | `personal-time-tracking` | `time-tracking-report` | `work-item-exporter`

### `time_tracking_field_type`

`text` | `number` | `date` | `dropdown`

### `permission_name`

`project-read-project-basic` | `project-create-project` | `project-read-project-full` | `project-update-project` | `project-delete-project` | `organization-read-organization` | `organization-update-organization` | `organization-create-organization` | `organization-delete-organization` | `user-profile-update-self` | `user-read-user-basic` | `user-read-user-details` | `user-update-user` | `user-create-user` | `user-delete-user` | `system-low-level-admin-read` | `system-low-level-admin-write` | `issue-read-issue` | `issue-read-issue-private-fields` | `issue-update-issue` | `issue-create-issue` | `issue-delete-issue` | `issue-link-issues` | `issue-update-issue-private-fields` | `issue-apply-commands-silently` | `issue-view-watchers` | `issue-update-watchers` | `issue-view-voters` | `attachment-add-attachment` | `attachment-update-attachment` | `attachment-delete-attachment` | `comment-create-issue-comment` | `comment-read-issue-comment` | `comment-update-issue-comment` | `comment-delete-issue-comment` | `comment-update-not-own-issue-comment` | `comment-delete-not-own-comment-and-permanent-comment-delete` | `comment-read-article-comment` | `comment-create-article-comment` | `comment-update-article-comment` | `comment-delete-article-comment` | `visibility-override-visibility-restrictions` | `issue-work-item-read-work-item` | `issue-work-item-update-work-item` | `issue-work-item-update-not-own-work-item` | `issue-work-item-create-work-item` | `issue-work-item-create-not-own-work-item` | `article-read-article` | `article-create-article` | `article-update-article` | `article-delete-article` | `app-read-app-content` | `app-update-app-content`

