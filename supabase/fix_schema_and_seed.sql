-- ==============================================================
-- Fix schema + insert sample project members
-- Run this in Supabase SQL Editor
-- ==============================================================

-- 1. Fix projects table: rename key -> project_key, owner_id -> owner, add missing columns
ALTER TABLE public.projects
  ADD COLUMN IF NOT EXISTS project_key TEXT,
  ADD COLUMN IF NOT EXISTS owner TEXT,
  ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_template BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS template_id TEXT,
  ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS member_initials JSONB DEFAULT '[]'::jsonb;

UPDATE public.projects SET project_key = "key" WHERE project_key IS NULL;
UPDATE public.projects SET owner = owner_id WHERE owner IS NULL;

ALTER TABLE public.projects ALTER COLUMN project_key SET NOT NULL;
ALTER TABLE public.projects ADD CONSTRAINT projects_project_key_unique UNIQUE (project_key);

-- 2. Fix project_members table: add new columns for Flutter app
ALTER TABLE public.project_members
  ADD COLUMN IF NOT EXISTS name TEXT,
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS roles JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS avatar_url TEXT,
  ADD COLUMN IF NOT EXISTS is_owner BOOLEAN NOT NULL DEFAULT false;

-- Migrate existing data: set name/email from users table, roles from role, is_owner from role
UPDATE public.project_members pm
SET
  name = COALESCE(u.full_name, 'User'),
  email = COALESCE(u.email, 'user@youtrack.app'),
  roles = CASE
    WHEN pm.role = 'admin' THEN '["System Admin", "Project Admin", "Contributor"]'::jsonb
    WHEN pm.role = 'developer' THEN '["Developer", "Contributor"]'::jsonb
    WHEN pm.role = 'reporter' THEN '["Reporter"]'::jsonb
    ELSE to_jsonb(ARRAY[pm.role])
  END,
  is_owner = (pm.role = 'admin' OR pm.role = 'owner')
FROM public.users u
WHERE u.id = pm.user_id::uuid;

-- For members without a matching users record, set defaults
UPDATE public.project_members
SET
  name = 'Unknown User',
  email = 'unknown@youtrack.app',
  roles = CASE
    WHEN role = 'admin' THEN '["System Admin", "Project Admin", "Contributor"]'::jsonb
    WHEN role = 'developer' THEN '["Developer", "Contributor"]'::jsonb
    WHEN role = 'reporter' THEN '["Reporter"]'::jsonb
    ELSE to_jsonb(ARRAY[role])
  END,
  is_owner = (role = 'admin' OR role = 'owner')
WHERE name IS NULL;

-- 3. Insert additional sample members with various roles (for each project)
DO $$
DECLARE
  proj RECORD;
BEGIN
  FOR proj IN (SELECT id, project_key FROM public.projects) LOOP
    -- Developer member
    INSERT INTO public.project_members (project_id, name, email, roles, is_owner, user_id)
    VALUES (
      proj.id,
      'Developer Team',
      'dev-team@youtrack.app',
      '["Developer", "Contributor"]'::jsonb,
      false,
      '00000000-0000-0000-0000-000000000001'
    ) ON CONFLICT DO NOTHING;

    -- Reporter member
    INSERT INTO public.project_members (project_id, name, email, roles, is_owner, user_id)
    VALUES (
      proj.id,
      'Reporter Team',
      'reporter-team@youtrack.app',
      '["Reporter"]'::jsonb,
      false,
      '00000000-0000-0000-0000-000000000002'
    ) ON CONFLICT DO NOTHING;
  END LOOP;
END $$;

-- 4. Verify
SELECT p.project_key, p.name AS project_name,
       pm.name AS member_name, pm.roles, pm.is_owner
FROM public.project_members pm
JOIN public.projects p ON p.id = pm.project_id
ORDER BY p.project_key, pm.name;
