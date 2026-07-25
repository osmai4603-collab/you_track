-- Run this in your Supabase SQL Editor (https://app.supabase.com/project/_/sql)

-- 1. Add missing columns to 'projects' table
ALTER TABLE public.projects
  ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_template BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS template_id TEXT,
  ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS member_initials JSONB DEFAULT '[]'::jsonb;

-- 2. Rename 'key' to 'project_key' if it exists to match ProjectModel
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name='projects' AND column_name='key') THEN
    ALTER TABLE public.projects RENAME COLUMN "key" TO "project_key";
  END IF;
END $$;

-- 3. Handle 'owner' column mismatch
-- The app sends 'admin' (TEXT). The original schema might have 'owner_id' (UUID).
DO $$
BEGIN
  -- If 'owner_id' exists, rename it to 'owner' and change type to TEXT
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name='projects' AND column_name='owner_id') THEN
    ALTER TABLE public.projects RENAME COLUMN "owner_id" TO "owner";
    ALTER TABLE public.projects ALTER COLUMN "owner" TYPE TEXT;
  END IF;

  -- If 'owner' doesn't exist at all, create it
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name='projects' AND column_name='owner') THEN
    ALTER TABLE public.projects ADD COLUMN owner TEXT NOT NULL DEFAULT 'admin';
  END IF;
END $$;

-- 4. Refresh PostgREST schema cache (Supabase does this automatically, but sometimes a manual toggle helps)
-- NOTIFY pgrst, 'reload schema';
