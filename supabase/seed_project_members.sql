-- Insert sample project members with roles
-- Run this in Supabase SQL Editor (https://app.supabase.com/project/_/sql)

-- First check existing projects
DO $$
DECLARE
  proj RECORD;
BEGIN
  FOR proj IN (SELECT id, project_key, name FROM public.projects) LOOP
    RAISE NOTICE 'Project: % (%)', proj.name, proj.project_key;

    -- Insert Project Admin (owner)
    INSERT INTO public.project_members (project_id, name, email, roles, is_owner)
    VALUES (proj.id, 'Admin User', 'admin@youtrack.app', '["System Admin", "Project Admin", "Contributor"]'::jsonb, true)
    ON CONFLICT DO NOTHING;

    -- Insert Developer
    INSERT INTO public.project_members (project_id, name, email, roles, is_owner)
    VALUES (proj.id, 'Developer', 'dev@youtrack.app', '["Developer", "Contributor"]'::jsonb, false)
    ON CONFLICT DO NOTHING;

    -- Insert Reporter
    INSERT INTO public.project_members (project_id, name, email, roles, is_owner)
    VALUES (proj.id, 'Reporter', 'reporter@youtrack.app', '["Reporter"]'::jsonb, false)
    ON CONFLICT DO NOTHING;
  END LOOP;
END $$;

-- Verify
SELECT p.project_key, p.name AS project_name,
       pm.name AS member_name, pm.roles, pm.is_owner
FROM public.project_members pm
JOIN public.projects p ON p.id = pm.project_id
ORDER BY p.project_key, pm.name;
