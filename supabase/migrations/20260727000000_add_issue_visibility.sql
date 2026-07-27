-- Add visibility column to issues table for group-based access control
ALTER TABLE issues
ADD COLUMN visibility jsonb DEFAULT '["team"]'::jsonb;

-- Create GIN index for efficient visibility array queries
CREATE INDEX idx_issues_visibility ON issues USING gin (visibility);

-- RLS policy for visibility-based access
CREATE POLICY "Users can view issues based on visibility"
  ON issues FOR SELECT
  USING (
    -- Team members can see team-visible issues
    (visibility @> '["team"]'::jsonb AND auth.uid() IN (
      SELECT user_id FROM project_members WHERE project_id = issues.project_key
    ))
    OR
    -- All authenticated users can see registered-visible issues
    (visibility @> '["registered"]'::jsonb AND auth.uid() IS NOT NULL)
    OR
    -- Specific users can see user-targeted issues
    (visibility @> jsonb_build_array('user:' || auth.uid()::text))
    OR
    -- Reporter can always see their own issues
    (reporter_id = auth.uid()::text)
  );
