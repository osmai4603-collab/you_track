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

CREATE INDEX idx_articles_project_id ON articles(project_id);
CREATE INDEX idx_articles_parent_id ON articles(parent_id);
CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_articles_sort ON articles(project_id, parent_id, sort_order);

ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY articles_select ON articles
  FOR SELECT USING (
    (status = 'published' AND visibility @> ARRAY[auth.uid()::text])
    OR created_by = auth.uid()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY articles_insert ON articles
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'developer'))
  );

CREATE POLICY articles_update ON articles
  FOR UPDATE USING (
    created_by = auth.uid()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY articles_delete ON articles
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
