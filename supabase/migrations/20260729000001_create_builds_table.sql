-- Migration: create_builds_table
-- Created: 2026-07-29

CREATE TABLE builds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  date TIMESTAMPTZ,
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_builds_project_id ON builds(project_id);

-- Add build_id column (uuid FK to builds) alongside existing fixed_in_build
ALTER TABLE issues ADD COLUMN build_id UUID REFERENCES builds(id);
CREATE INDEX idx_issues_build_id ON issues(build_id);
