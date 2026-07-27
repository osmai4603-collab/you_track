-- Knowledge Base tables migration (corrected)
-- Run this in Supabase SQL Editor

-- 1. Articles table
CREATE TABLE IF NOT EXISTS articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES articles(id) ON DELETE SET NULL,
  title TEXT NOT NULL CHECK (length(title) > 0),
  content_markdown TEXT NOT NULL DEFAULT '',
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  visibility TEXT[] NOT NULL DEFAULT ARRAY['admin', 'developer', 'visitor'],
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_by UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_articles_project_id ON articles(project_id);
CREATE INDEX IF NOT EXISTS idx_articles_parent_id ON articles(parent_id);
CREATE INDEX IF NOT EXISTS idx_articles_status ON articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_sort ON articles(project_id, parent_id, sort_order);

ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- SELECT: published articles visible to all authenticated; drafts visible to author
CREATE POLICY articles_select ON articles
  FOR SELECT USING (
    auth.uid() IS NOT NULL
  );

-- INSERT: authenticated users can create articles
CREATE POLICY articles_insert ON articles
  FOR INSERT WITH CHECK (
    auth.uid() IS NOT NULL
    AND created_by = auth.uid()
  );

-- UPDATE: author or anyone for now (can restrict later)
CREATE POLICY articles_update ON articles
  FOR UPDATE USING (
    auth.uid() IS NOT NULL
  );

-- DELETE: author can delete their own
CREATE POLICY articles_delete ON articles
  FOR DELETE USING (
    auth.uid() IS NOT NULL
  );

-- 2. Article comments table
CREATE TABLE IF NOT EXISTS article_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id UUID NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES auth.users(id),
  comment_text TEXT NOT NULL CHECK (length(comment_text) > 0),
  anchor_text TEXT NOT NULL DEFAULT '',
  anchor_start INTEGER NOT NULL DEFAULT 0 CHECK (anchor_start >= 0),
  anchor_end INTEGER NOT NULL DEFAULT 0 CHECK (anchor_end >= anchor_start),
  is_resolved BOOLEAN NOT NULL DEFAULT false,
  resolved_by UUID REFERENCES auth.users(id),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_article_comments_article_id ON article_comments(article_id);
CREATE INDEX IF NOT EXISTS idx_article_comments_author_id ON article_comments(author_id);
CREATE INDEX IF NOT EXISTS idx_article_comments_resolved ON article_comments(article_id, is_resolved);

ALTER TABLE article_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY article_comments_select ON article_comments
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY article_comments_insert ON article_comments
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL AND author_id = auth.uid());

CREATE POLICY article_comments_update ON article_comments
  FOR UPDATE USING (auth.uid() IS NOT NULL);

CREATE POLICY article_comments_delete ON article_comments
  FOR DELETE USING (auth.uid() IS NOT NULL);

-- 3. Article notifications table
CREATE TABLE IF NOT EXISTS article_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_id UUID NOT NULL REFERENCES auth.users(id),
  sender_id UUID NOT NULL REFERENCES auth.users(id),
  article_id UUID NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES article_comments(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL DEFAULT 'mention' CHECK (notification_type IN ('mention')),
  is_read BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_article_notifications_recipient ON article_notifications(recipient_id, is_read);
CREATE INDEX IF NOT EXISTS idx_article_notifications_created ON article_notifications(created_at DESC);

ALTER TABLE article_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY article_notifications_select ON article_notifications
  FOR SELECT USING (recipient_id = auth.uid());

CREATE POLICY article_notifications_insert ON article_notifications
  FOR INSERT WITH CHECK (true);

CREATE POLICY article_notifications_update ON article_notifications
  FOR UPDATE USING (recipient_id = auth.uid());
