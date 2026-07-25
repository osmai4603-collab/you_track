-- Create custom_fields table
CREATE TABLE custom_fields (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  type VARCHAR(20) NOT NULL CHECK (type IN ('build', 'enum', 'group', 'owned-field', 'state', 'user', 'version')),
  is_private BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(project_id, name)
);

-- Enable RLS
ALTER TABLE custom_fields ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view custom fields in their projects"
  ON custom_fields FOR SELECT
  USING (project_id IN (
    SELECT project_id FROM project_members WHERE user_id = auth.uid()
  ));

CREATE POLICY "Project admins can manage custom fields"
  ON custom_fields FOR ALL
  USING (project_id IN (
    SELECT project_id FROM project_members 
    WHERE user_id = auth.uid() AND role = 'admin'
  ));

-- Create index for performance
CREATE INDEX idx_custom_fields_project_id ON custom_fields(project_id);