CREATE TABLE IF NOT EXISTS article_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id UUID NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES auth.users(id),
  comment_text TEXT NOT NULL CHECK (length(comment_text) > 0),
  anchor_text TEXT NOT NULL,
  anchor_start INTEGER NOT NULL CHECK (anchor_start >= 0),
  anchor_end INTEGER NOT NULL CHECK (anchor_end > anchor_start),
  is_resolved BOOLEAN NOT NULL DEFAULT false,
  resolved_by UUID REFERENCES auth.users(id),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_article_comments_article_id ON article_comments(article_id);
CREATE INDEX idx_article_comments_author_id ON article_comments(author_id);
CREATE INDEX idx_article_comments_resolved ON article_comments(article_id, is_resolved);

ALTER TABLE article_comments ENABLE ROW LEVEL SECURITY;

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
