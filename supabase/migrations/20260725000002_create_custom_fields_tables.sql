CREATE TABLE custom_fields (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  field_type TEXT NOT NULL CHECK (field_type IN ('issue-type', 'priority', 'state', 'subsystem')),
  default_value TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(project_id, name)
);

ALTER TABLE custom_fields ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Project members can view custom_fields"
  ON custom_fields FOR SELECT
  USING (auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = custom_fields.project_id));

CREATE POLICY "Project admins can manage custom_fields"
  ON custom_fields FOR ALL
  USING (auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = custom_fields.project_id AND 'project-admin' = ANY(roles)));

CREATE TABLE custom_field_values (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  issue_id UUID NOT NULL REFERENCES issues(id) ON DELETE CASCADE,
  custom_field_id UUID NOT NULL REFERENCES custom_fields(id) ON DELETE RESTRICT,
  value TEXT NOT NULL,
  UNIQUE(issue_id, custom_field_id)
);

ALTER TABLE custom_field_values ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Project members can view custom_field_values"
  ON custom_field_values FOR SELECT
  USING (
    auth.uid() IN (
      SELECT user_id FROM project_members
      WHERE project_id = (
        SELECT project_id FROM issues WHERE id = custom_field_values.issue_id
      )
    )
  );

CREATE POLICY "Project members can manage custom_field_values"
  ON custom_field_values FOR ALL
  USING (
    auth.uid() IN (
      SELECT user_id FROM project_members
      WHERE project_id = (
        SELECT project_id FROM issues WHERE id = custom_field_values.issue_id
      )
    )
  );
