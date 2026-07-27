# Data Model: Knowledge Base

**Date**: 2026-07-26 | **Feature**: 009-knowledge-base

## Entity: Article

A document in the knowledge base, organized in a parent-child hierarchy.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | UUID | PK, default `gen_random_uuid()` | Unique article identifier |
| `project_id` | UUID | FK → `projects.id`, NOT NULL, ON DELETE CASCADE | Project this article belongs to |
| `parent_id` | UUID | FK → `articles.id`, NULLABLE | Parent article (null = root article) |
| `title` | TEXT | NOT NULL, CHECK length > 0 | Article title |
| `content_markdown` | TEXT | NOT NULL, default `''` | Raw Markdown content |
| `status` | TEXT | NOT NULL, default `'draft'`, CHECK IN ('draft','published') | Article status |
| `visibility` | TEXT[] | NOT NULL, default `'{admin,developer,visitor}'` | Roles that can see this article |
| `sort_order` | INTEGER | NOT NULL, default `0` | Numeric position among siblings |
| `created_by` | UUID | FK → auth.users.id, NOT NULL | Author user ID |
| `created_at` | TIMESTAMPTZ | NOT NULL, default `now()` | Creation timestamp |
| `updated_at` | TIMESTAMPTZ | NOT NULL, default `now()` | Last modification timestamp |

**Indexes**:
- `idx_articles_project_id` ON `project_id`
- `idx_articles_parent_id` ON `parent_id`
- `idx_articles_status` ON `status`
- `idx_articles_sort` ON `(project_id, parent_id, sort_order)`
- `idx_articles_fulltext` GIN on `to_tsvector('english', title || ' ' || content_markdown)`

**RLS Policies**:
- `articles_select`: Users can SELECT where `status = 'published'` AND `visibility @> ARRAY[user_role]`, OR where `created_by = auth.uid()` (own drafts), OR where `user_role = 'admin'`
- `articles_insert`: Only users with role IN ('admin', 'developer') can INSERT
- `articles_update`: Only `created_by = auth.uid()` OR `user_role = 'admin'` can UPDATE
- `articles_delete`: Only `user_role = 'admin'` can DELETE

**State Transitions**:
```
draft → published (via publish action)
published → draft (via unpublish, admin only)
```

---

## Entity: Article Comment

A user remark anchored to a specific text selection within an article.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | UUID | PK, default `gen_random_uuid()` | Unique comment identifier |
| `article_id` | UUID | FK → `articles.id`, NOT NULL, ON DELETE CASCADE | Article this comment belongs to |
| `author_id` | UUID | FK → auth.users.id, NOT NULL | Comment author |
| `comment_text` | TEXT | NOT NULL, CHECK length > 0 | Comment body text |
| `anchor_text` | TEXT | NOT NULL | The selected text this comment is anchored to |
| `anchor_start` | INTEGER | NOT NULL, CHECK >= 0 | Start offset of anchor in article content |
| `anchor_end` | INTEGER | NOT NULL, CHECK > anchor_start | End offset of anchor in article content |
| `is_resolved` | BOOLEAN | NOT NULL, default `false` | Whether comment is resolved |
| `resolved_by` | UUID | FK → auth.users.id, NULLABLE | Who resolved it |
| `resolved_at` | TIMESTAMPTZ | NULLABLE | When it was resolved |
| `created_at` | TIMESTAMPTZ | NOT NULL, default `now()` | Creation timestamp |

**Indexes**:
- `idx_article_comments_article_id` ON `article_id`
- `idx_article_comments_author_id` ON `author_id`
- `idx_article_comments_resolved` ON `(article_id, is_resolved)`

**RLS Policies**:
- `article_comments_select`: Users can SELECT where the parent article's visibility matches their role (same as articles_select)
- `article_comments_insert`: Authenticated users can INSERT
- `article_comments_update`: Only `author_id = auth.uid()` OR `user_role = 'admin'` can UPDATE (resolve)
- `article_comments_delete`: Only `author_id = auth.uid()` OR `user_role = 'admin'` can DELETE

---

## Entity: Article Draft

Local-only entity for offline draft persistence. Stored in Hive, NOT in Supabase.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `article_id` | UUID | PK | Reference to server article |
| `content_markdown` | TEXT | NOT NULL | Locally saved draft content |
| `title` | TEXT | NOT NULL | Locally saved draft title |
| `saved_at` | DateTime | NOT NULL | Local save timestamp |
| `synced` | bool | NOT NULL, default `false` | Whether synced to server |

**Sync strategy**: On app launch and network restoration, iterate unsynced drafts and PATCH to Supabase. Conflict resolution: last-write-wins based on `updated_at`.

---

## Entity: Article Notification

A real-time alert triggered by an @mention in a comment.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | UUID | PK, default `gen_random_uuid()` | Unique notification identifier |
| `recipient_id` | UUID | FK → auth.users.id, NOT NULL | User who receives the notification |
| `sender_id` | UUID | FK → auth.users.id, NOT NULL | User who triggered the notification |
| `article_id` | UUID | FK → `articles.id`, NOT NULL, ON DELETE CASCADE | Related article |
| `comment_id` | UUID | FK → `article_comments.id`, NULLABLE, ON DELETE CASCADE | Related comment |
| `notification_type` | TEXT | NOT NULL, default `'mention'`, CHECK IN ('mention') | Type of notification |
| `is_read` | BOOLEAN | NOT NULL, default `false` | Whether user has seen it |
| `created_at` | TIMESTAMPTZ | NOT NULL, default `now()` | Creation timestamp |

**Indexes**:
- `idx_article_notifications_recipient` ON `(recipient_id, is_read)`
- `idx_article_notifications_created` ON `created_at DESC`

**RLS Policies**:
- `article_notifications_select`: Users can SELECT only where `recipient_id = auth.uid()`
- `article_notifications_insert`: System (via service role or database trigger) can INSERT
- `article_notifications_update`: Users can UPDATE only their own (mark as read)

**Realtime**: Supabase Realtime subscription scoped to `article_notifications` table, filtered by `recipient_id = current_user.id`, only INSERT events.

---

## Relationships

```
projects 1──N articles (project_id)
articles 1──N articles (parent_id) — self-referential tree
articles 1──N article_comments (article_id)
articles 1──N article_drafts (article_id) — local only
articles 1──N article_notifications (article_id)
article_comments 1──N article_notifications (comment_id)
auth.users 1──N articles (created_by)
auth.users 1──N article_comments (author_id)
auth.users 1──N article_notifications (recipient_id / sender_id)
```
