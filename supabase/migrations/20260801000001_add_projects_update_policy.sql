-- Migration: add_projects_update_policy
-- Created: 2026-08-01
-- Fixes PGRST116 ("The result contains 0 rows") on project save:
-- the projects table had RLS enabled but no UPDATE policy, so authenticated
-- UPDATE statements were silently blocked (0 rows affected).

CREATE POLICY "Project owners and admins can update projects"
  ON public.projects
  FOR UPDATE
  TO authenticated
  USING (
    owner_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.project_members pm
      WHERE pm.project_id = id
        AND pm.user_id = auth.uid()
        AND pm.role IN ('admin', 'owner')
    )
  );

CREATE POLICY "Project owners and admins can delete projects"
  ON public.projects
  FOR DELETE
  TO authenticated
  USING (
    owner_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.project_members pm
      WHERE pm.project_id = id
        AND pm.user_id = auth.uid()
        AND pm.role IN ('admin', 'owner')
    )
  );
