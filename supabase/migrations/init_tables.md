## Table `users`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `email` | `text` |  Unique |
| `full_name` | `text` |  Nullable |
| `avatar_url` | `text` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |

## Table `projects`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `key` | `text` |  Unique |
| `name` | `text` |  |
| `description` | `text` |  Nullable |
| `owner_id` | `uuid` |  Nullable |
| `created_at` | `timestamptz` |  Nullable |
| `project_id` | `text` |  |

## Table `builds`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  |
| `date` | `timestamptz` |  Nullable |
| `project_id` | `uuid` |  |

## Table `project_members`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `project_id` | `uuid` | Primary |
| `user_id` | `uuid` | Primary |
| `role` | `text` |  |

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
| `visibility` | `_text` |  Nullable |
| `subsystem` | `text` |  |
| `fix_versions` | `text` |  |
| `build_id` | `uuid` |  Nullable |

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

## RLS Policies

### `notifications`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Users can update own notifications` | UPDATE | authenticated | PERMISSIVE | `(auth.uid() = user_id)` | `(auth.uid() = user_id)` |
| `Users can view own notifications` | SELECT | authenticated | PERMISSIVE | `(auth.uid() = user_id)` | — |

### `dashboard_widgets`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can add widgets` | INSERT | public | PERMISSIVE | — | `true` |
| `Anyone can view dashboard widgets` | SELECT | public | PERMISSIVE | `true` | — |
| `Users can manage widgets of own dashboards` | ALL | public | PERMISSIVE | `(dashboard_id IN ( SELECT dashboards.id    FROM dashboards   WHERE (dashboards.owner_id = auth.uid())))` | — |
| `Users can view widgets of shared dashboards` | SELECT | public | PERMISSIVE | `(dashboard_id IN ( SELECT dashboard_shares.dashboard_id    FROM dashboard_shares   WHERE (dashboard_shares.user_id = auth.uid())))` | — |

### `dashboards`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can create dashboards` | INSERT | public | PERMISSIVE | — | `true` |
| `Anyone can view dashboards` | SELECT | public | PERMISSIVE | `true` | — |
| `Users can manage own dashboards` | ALL | public | PERMISSIVE | `(auth.uid() = owner_id)` | — |
| `Users can view own dashboards` | SELECT | public | PERMISSIVE | `(auth.uid() = owner_id)` | — |
| `Users can view shared dashboards` | SELECT | public | PERMISSIVE | `(id IN ( SELECT dashboard_shares.dashboard_id    FROM dashboard_shares   WHERE (dashboard_shares.user_id = auth.uid())))` | — |

### `tags`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view tags` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can manage tags` | ALL | authenticated | PERMISSIVE | `true` | `true` |

### `tag_permissions`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view tag_permissions` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can manage tag_permissions` | ALL | authenticated | PERMISSIVE | `true` | `true` |

### `tag_subscriptions`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view tag_subscriptions` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can manage tag_subscriptions` | ALL | authenticated | PERMISSIVE | `true` | `true` |

### `issue_tags`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view issue_tags` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can manage issue_tags` | ALL | authenticated | PERMISSIVE | `true` | `true` |

### `issues`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view issues` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can create issues` | INSERT | authenticated | PERMISSIVE | — | `true` |
| `Users can update issues they reported or assigned to` | UPDATE | authenticated | PERMISSIVE | `((auth.uid() = reporter_id) OR (auth.uid() = assignee_id))` | `((auth.uid() = reporter_id) OR (auth.uid() = assignee_id))` |

### `comments`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view comments` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can insert comments` | INSERT | authenticated | PERMISSIVE | — | `(auth.uid() = user_id)` |
| `Users can update their own comments` | UPDATE | authenticated | PERMISSIVE | `(auth.uid() = user_id)` | `(auth.uid() = user_id)` |

### `projects`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view projects` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can create projects` | INSERT | authenticated | PERMISSIVE | — | `true` |

### `attachments`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view attachments` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can insert attachments` | INSERT | authenticated | PERMISSIVE | — | `(auth.uid() = user_id)` |
| `Users can update own attachments` | UPDATE | authenticated | PERMISSIVE | `(auth.uid() = user_id)` | `(auth.uid() = user_id)` |

### `issue_links`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `Anyone can view issue links` | SELECT | public | PERMISSIVE | `true` | — |
| `Authenticated users can create issue links` | INSERT | authenticated | PERMISSIVE | — | `true` |
| `Authenticated users can delete issue links` | DELETE | authenticated | PERMISSIVE | `true` | — |

### `articles`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `articles_delete` | DELETE | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | — |
| `articles_insert` | INSERT | public | PERMISSIVE | — | `((auth.uid() IS NOT NULL) AND (created_by = auth.uid()))` |
| `articles_select` | SELECT | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | — |
| `articles_update` | UPDATE | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | — |

### `article_comments`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `article_comments_delete` | DELETE | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | — |
| `article_comments_insert` | INSERT | public | PERMISSIVE | — | `((auth.uid() IS NOT NULL) AND (author_id = auth.uid()))` |
| `article_comments_select` | SELECT | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | — |
| `article_comments_update` | UPDATE | public | PERMISSIVE | `(auth.uid() IS NOT NULL)` | — |

### `article_notifications`

| Policy | Command | Roles | Action | USING | WITH CHECK |
|--------|---------|-------|--------|-------|------------|
| `article_notifications_insert` | INSERT | public | PERMISSIVE | — | `true` |
| `article_notifications_select` | SELECT | public | PERMISSIVE | `(recipient_id = auth.uid())` | — |
| `article_notifications_update` | UPDATE | public | PERMISSIVE | `(recipient_id = auth.uid())` | — |

