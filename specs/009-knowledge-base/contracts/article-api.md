# Supabase Table Contracts: Knowledge Base

**Date**: 2026-07-26 | **Feature**: 009-knowledge-base

This document defines the Supabase query patterns and RLS contract for the knowledge base feature.

---

## Table: articles

### Query Patterns

| Operation | Supabase Client Call | Notes |
|-----------|---------------------|-------|
| Get all articles for project | `supabase.from('articles').select('*').eq('project_id', projectId).order('sort_order')` | Returns flat list; tree built client-side |
| Get single article | `supabase.from('articles').select('*').eq('id', articleId).single()` | |
| Get articles by status | `supabase.from('articles').select('*').eq('project_id', projectId).eq('status', status)` | |
| Create article | `supabase.from('articles').insert(data).select().single()` | Removes `id` from insert data; DB generates UUID |
| Update article | `supabase.from('articles').update(data).eq('id', articleId).select().single()` | |
| Delete article | `supabase.from('articles').delete().eq('id', articleId)` | Children re-parented before delete |
| Reorder siblings | `supabase.from('articles').update({'sort_order': newOrder}).eq('id', articleId)` | Batch update for multiple articles |
| Search articles | `supabase.from('articles').select('*').eq('project_id', projectId).textSearch('title', query)` | Uses GIN index |

### RLS Policies

```sql
-- SELECT: published articles visible by role, own drafts, admin sees all
CREATE POLICY articles_select ON articles
  FOR SELECT USING (
    (status = 'published' AND visibility @> ARRAY[auth.uid()::text])
    OR created_by = auth.uid()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- INSERT: admin and developer only
CREATE POLICY articles_insert ON articles
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'developer'))
  );

-- UPDATE: author or admin
CREATE POLICY articles_update ON articles
  FOR UPDATE USING (
    created_by = auth.uid()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- DELETE: admin only
CREATE POLICY articles_delete ON articles
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

---

## Table: article_comments

### Query Patterns

| Operation | Supabase Client Call | Notes |
|-----------|---------------------|-------|
| Get comments for article | `supabase.from('article_comments').select('*').eq('article_id', articleId).order('created_at')` | |
| Get unresolved comments | `supabase.from('article_comments').select('*').eq('article_id', articleId).eq('is_resolved', false)` | |
| Add comment | `supabase.from('article_comments').insert(data).select().single()` | |
| Resolve comment | `supabase.from('article_comments').update({'is_resolved': true, 'resolved_by': userId, 'resolved_at': now}).eq('id', commentId)` | |
| Delete comment | `supabase.from('article_comments').delete().eq('id', commentId)` | |

### RLS Policies

```sql
CREATE POLICY article_comments_select ON article_comments
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM articles WHERE id = article_id AND (
      (status = 'published' AND visibility @> ARRAY[auth.uid()::text])
      OR created_by = auth.uid()
      OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
    ))
  );

CREATE POLICY article_comments_insert ON article_comments
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY article_comments_update ON article_comments
  FOR UPDATE USING (
    author_id = auth.uid()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY article_comments_delete ON article_comments
  FOR DELETE USING (
    author_id = auth.uid()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

---

## Table: article_notifications

### Query Patterns

| Operation | Supabase Client Call | Notes |
|-----------|---------------------|-------|
| Get unread notifications | `supabase.from('article_notifications').select('*').eq('recipient_id', userId).eq('is_read', false).order('created_at', ascending: false)` | |
| Mark as read | `supabase.from('article_notifications').update({'is_read': true}).eq('id', notificationId)` | |
| Mark all as read | `supabase.from('article_notifications').update({'is_read': true}).eq('recipient_id', userId).eq('is_read', false)` | |

### Realtime Subscription

```dart
supabase
  .from('article_notifications')
  .stream(primaryKey: ['id'])
  .eq('recipient_id', currentUserId)
  .listen((data) {
    // Handle new notification
  });
```

### RLS Policies

```sql
CREATE POLICY article_notifications_select ON article_notifications
  FOR SELECT USING (recipient_id = auth.uid());

CREATE POLICY article_notifications_insert ON article_notifications
  FOR INSERT WITH CHECK (true); -- System-level inserts via trigger or service role

CREATE POLICY article_notifications_update ON article_notifications
  FOR UPDATE USING (recipient_id = auth.uid());
```

---

## Triggers

A database trigger on `article_comments` INSERT automatically creates an `article_notifications` row for each @mention found in the comment text. This ensures notifications are created atomically with the comment.

```sql
CREATE OR REPLACE FUNCTION create_mention_notifications()
RETURNS TRIGGER AS $$
BEGIN
  -- Parse @username mentions from NEW.comment_text
  -- Insert into article_notifications for each mentioned user
  -- (Implementation uses regex matching against profiles.display_name)
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_mention_notifications
  AFTER INSERT ON article_comments
  FOR EACH ROW
  EXECUTE FUNCTION create_mention_notifications();
```
