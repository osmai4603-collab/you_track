-- Migration: fix_issue_key_trigger
-- Fixes: "null value in column issue_key of relation issues violates not-null constraint"
--
-- Root cause:
-- The BEFORE INSERT trigger set_issue_sequence_and_key() reads the project key
-- from projects.key, but projects created via the app store the key in the
-- projects.project_id column (key stays NULL). NULL || '-' || seq evaluates to
-- NULL, overwriting the app-provided issue_key with NULL.

-- 1) Backfill projects.key for rows where it was never written
UPDATE public.projects
SET key = project_id
WHERE key IS NULL AND project_id IS NOT NULL;

-- 2) Recreate the trigger function to read the key from project_id (the column
--    written by the app), falling back to key.
CREATE OR REPLACE FUNCTION set_issue_sequence_and_key()
RETURNS TRIGGER AS $$
DECLARE
    next_seq INTEGER;
    proj_key TEXT;
BEGIN
    SELECT COALESCE(project_id, key) INTO proj_key
    FROM public.projects
    WHERE id = NEW.project_id;

    SELECT COALESCE(MAX(issue_sequence), 0) + 1 INTO next_seq
    FROM public.issues
    WHERE project_id = NEW.project_id;

    NEW.issue_sequence = next_seq;
    NEW.issue_key = proj_key || '-' || next_seq::TEXT;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
