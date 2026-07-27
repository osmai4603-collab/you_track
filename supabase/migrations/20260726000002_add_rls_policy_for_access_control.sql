-- Drop existing SELECT policy to replace it
DROP POLICY IF EXISTS "Users can view custom fields in their projects" ON custom_fields;

-- Create new SELECT policy with access_control support
CREATE POLICY "Users can view custom fields based on access control"
ON custom_fields
FOR SELECT
USING (
  -- Everyone can see (default)
  access_control->>'type' = 'everyone'
  OR
  -- Admins only
  (
    access_control->>'type' = 'admins_only'
    AND EXISTS (
      SELECT 1 FROM project_members
      WHERE user_id = auth.uid()
      AND project_id = custom_fields.project_id
      AND role IN ('owner', 'admin')
    )
  )
  OR
  -- Custom: users directly assigned
  (
    access_control->>'type' = 'custom'
    AND auth.uid() = ANY(
      ARRAY(SELECT jsonb_array_elements_text(access_control->'users'))
    )
  )
  OR
  -- Custom: users in assigned groups
  (
    access_control->>'type' = 'custom'
    AND EXISTS (
      SELECT 1 FROM user_groups_members ugm
      WHERE ugm.group_id = ANY(
        ARRAY(SELECT jsonb_array_elements_text(access_control->'groups'))
      )
      AND ugm.user_id = auth.uid()
    )
  )
  OR
  -- Fallback: user is project member (for backward compatibility)
  (
    access_control->>'type' IS NULL
    AND project_id IN (
      SELECT project_id FROM project_members WHERE user_id = auth.uid()
    )
  )
);
