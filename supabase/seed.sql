-- ==============================================================
-- Seed data for YouTrack
-- Run this AFTER applying all migrations
-- Usage: psql "postgresql://postgres:password@db.jadgeemsdhhtrgnieumt.supabase.co:5432/postgres" -f seed.sql
-- OR run via Supabase Dashboard > SQL Editor
-- ==============================================================

-- Disable triggers temporarily for clean insert
SET session_replication_role = 'replica';

-- 1. USERS (public.users - extends auth.users)
INSERT INTO public.users (id, email, full_name) VALUES
  ('c8100558-f751-4561-be0a-236ae53a0b97', 'admin@youtrack.app', 'Admin User')
ON CONFLICT (id) DO NOTHING;

-- 2. SETTINGS
INSERT INTO public.settings (key, value, description, updated_by) VALUES
  ('app_name', 'YouTrack', 'Application display name', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('app_logo_url', '', 'URL to app logo', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('default_priority', 'Normal', 'Default priority for new issues', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('default_issue_type', 'Task', 'Default type for new issues', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('max_attachments_size_mb', '10', 'Maximum attachment size in MB', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('smtp_enabled', 'false', 'Enable SMTP email notifications', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('issue_auto_numbering', 'true', 'Auto-generate issue sequence numbers', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('allow_guest_access', 'false', 'Allow unauthenticated users to view issues', 'c8100558-f751-4561-be0a-236ae53a0b97')
ON CONFLICT (key) DO NOTHING;

-- 3. PROJECTS
INSERT INTO public.projects (key, name, description, owner_id) VALUES
  ('YT', 'YouTrack Mobile', 'Mobile application for YouTrack issue tracking system', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('WEB', 'Website Redesign', 'Complete redesign of the company website', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('API', 'API Gateway', 'Internal API gateway service for microservices', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('INFRA', 'Infrastructure', 'Cloud infrastructure and DevOps tasks', 'c8100558-f751-4561-be0a-236ae53a0b97'),
  ('MOBILE', 'Mobile App v2', 'Version 2 of the mobile application with new features', 'c8100558-f751-4561-be0a-236ae53a0b97');

-- 4. PROJECT MEMBERS
DO $$
DECLARE
  yt_id UUID;
  web_id UUID;
  api_id UUID;
  infra_id UUID;
  mobile_id UUID;
  user_id UUID := 'c8100558-f751-4561-be0a-236ae53a0b97';
BEGIN
  SELECT id INTO yt_id FROM public.projects WHERE key = 'YT';
  SELECT id INTO web_id FROM public.projects WHERE key = 'WEB';
  SELECT id INTO api_id FROM public.projects WHERE key = 'API';
  SELECT id INTO infra_id FROM public.projects WHERE key = 'INFRA';
  SELECT id INTO mobile_id FROM public.projects WHERE key = 'MOBILE';

  INSERT INTO public.project_members (project_id, user_id, role) VALUES
    (yt_id, user_id, 'admin'),
    (web_id, user_id, 'admin'),
    (api_id, user_id, 'admin'),
    (infra_id, user_id, 'admin'),
    (mobile_id, user_id, 'admin');
END $$;

-- 5. ISSUES
DO $$
DECLARE
  yt_id UUID;
  web_id UUID;
  api_id UUID;
  user_id UUID := 'c8100558-f751-4561-be0a-236ae53a0b97';
BEGIN
  SELECT id INTO yt_id FROM public.projects WHERE key = 'YT';
  SELECT id INTO web_id FROM public.projects WHERE key = 'WEB';
  SELECT id INTO api_id FROM public.projects WHERE key = 'API';

  -- YouTrack Mobile issues
  INSERT INTO public.issues (project_id, title, description, reporter_id, assignee_id, state, priority, issue_type) VALUES
    (yt_id, 'Fix login crash on Android 14', 'App crashes on Android 14 devices when attempting Google sign-in. Stack trace shows NullPointerException in auth flow.', user_id, user_id, 'Open', 'Critical', 'Bug'),
    (yt_id, 'Add dark mode support', 'Users have requested dark mode for the mobile app. Should follow system theme by default with manual override option.', user_id, user_id, 'In Progress', 'Normal', 'Feature'),
    (yt_id, 'Improve notification system', 'Rewrite notification service to use FCM v2. Need to handle push notifications for issue assignments and comments.', user_id, user_id, 'Open', 'Major', 'Task'),
    (yt_id, 'Fix pull-to-refresh animation', 'The pull-to-refresh animation stutters on Android. Need to optimize the animation timing.', user_id, user_id, 'Fixed', 'Minor', 'Bug'),
    (yt_id, 'Add issue attachment preview', 'Allow users to preview image attachments inline before downloading.', user_id, user_id, 'Verified', 'Normal', 'Feature');

  -- Website Redesign issues
  INSERT INTO public.issues (project_id, title, description, reporter_id, assignee_id, state, priority, issue_type) VALUES
    (web_id, 'Update hero section design', 'New hero section with animated background and CTA buttons. Design mockup is in Figma.', user_id, user_id, 'Open', 'Normal', 'Improvement'),
    (web_id, 'SEO optimization for product pages', 'Add meta tags, structured data (JSON-LD), and improve page load times for better search rankings.', user_id, user_id, 'Open', 'Major', 'Task'),
    (web_id, 'Fix mobile navigation menu', 'Mobile hamburger menu does not close when clicking outside. Also need to add smooth transitions.', user_id, user_id, 'In Progress', 'Normal', 'Bug'),
    (web_id, 'Implement lazy loading for images', 'Product images should lazy load with placeholder blur effect to improve initial page load.', user_id, user_id, 'Open', 'Minor', 'Improvement'),
    (web_id, 'Add contact form with validation', 'Implement a contact form with client-side and server-side validation, reCAPTCHA integration.', user_id, user_id, 'Open', 'Normal', 'Task');

  -- API Gateway issues
  INSERT INTO public.issues (project_id, title, description, reporter_id, assignee_id, state, priority, issue_type) VALUES
    (api_id, 'Rate limiting implementation', 'Implement token bucket rate limiting per API key. Default limit: 1000 requests/hour.', user_id, user_id, 'In Progress', 'Critical', 'Feature'),
    (api_id, 'Add request validation middleware', 'Validate all incoming requests using Zod schemas before they reach handlers.', user_id, user_id, 'Verified', 'Normal', 'Task'),
    (api_id, 'Implement API key rotation', 'Allow users to rotate their API keys with a 24-hour grace period before old key expires.', user_id, user_id, 'Open', 'Major', 'Feature'),
    (api_id, 'Add request logging with structured logs', 'Log all API requests in JSON format with correlation IDs for debugging.', user_id, user_id, 'Fixed', 'Normal', 'Task'),
    (api_id, 'Set up health check endpoint', 'Create /health endpoint that checks database connectivity, cache status, and downstream services.', user_id, user_id, 'Verified', 'Normal', 'Task');
END $$;

-- Re-enable triggers
SET session_replication_role = 'origin';

-- Verify
SELECT 'projects' as tbl, count(*) as cnt FROM public.projects
UNION ALL
SELECT 'project_members', count(*) FROM public.project_members
UNION ALL
SELECT 'issues', count(*) FROM public.issues
UNION ALL
SELECT 'settings', count(*) FROM public.settings
UNION ALL
SELECT 'users', count(*) FROM public.users;
