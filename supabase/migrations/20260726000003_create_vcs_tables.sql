-- Migration: 007_version_control_settings
-- Created: 2026-07-26
-- Description: Add VCS integration tables for version control settings feature

-- Enums
CREATE TYPE vcs_provider_type AS ENUM (
  'github', 'gitlab', 'bitbucket_cloud', 'bitbucket_server', 'gitea', 'custom_git'
);

CREATE TYPE vcs_auth_mode AS ENUM ('oauth', 'token', 'ssh');

CREATE TYPE vcs_connection_status AS ENUM (
  'connected', 'disabled', 'auth_failed', 'sync_error'
);

CREATE TYPE vcs_pr_state AS ENUM ('open', 'merged', 'closed');

-- Core table: VCS integrations
CREATE TABLE vcs_integrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  integration_name TEXT NOT NULL,
  provider_type vcs_provider_type NOT NULL,
  server_url TEXT,
  auth_mode vcs_auth_mode NOT NULL,
  encrypted_token TEXT,
  ssh_private_key TEXT,
  passphrase TEXT,
  organization_owner TEXT NOT NULL,
  repository_name TEXT NOT NULL,
  branch_specification TEXT NOT NULL DEFAULT '+:*',
  parse_commits_for_commands BOOLEAN NOT NULL DEFAULT false,
  silent_processing BOOLEAN NOT NULL DEFAULT false,
  pull_request_automation BOOLEAN NOT NULL DEFAULT false,
  command_executors_groups UUID[],
  visible_to_roles UUID[] NOT NULL DEFAULT '{}',
  automatic_user_mapping BOOLEAN NOT NULL DEFAULT true,
  status vcs_connection_status NOT NULL DEFAULT 'connected',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_vcs_integrations_project_id ON vcs_integrations(project_id);
CREATE INDEX idx_vcs_integrations_status ON vcs_integrations(status);

-- User mappings table
CREATE TABLE vcs_user_mappings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  integration_id UUID NOT NULL REFERENCES vcs_integrations(id) ON DELETE CASCADE,
  vcs_username_or_email TEXT NOT NULL,
  youtrack_user_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_vcs_user_mappings_integration_id ON vcs_user_mappings(integration_id);
CREATE INDEX idx_vcs_user_mappings_email ON vcs_user_mappings(vcs_username_or_email);

-- Commits table
CREATE TABLE vcs_commits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  integration_id UUID NOT NULL REFERENCES vcs_integrations(id) ON DELETE CASCADE,
  task_id UUID NOT NULL REFERENCES issues(id),
  commit_sha TEXT NOT NULL,
  author_name TEXT NOT NULL,
  author_email TEXT NOT NULL,
  message TEXT NOT NULL,
  branch TEXT NOT NULL,
  committed_at TIMESTAMPTZ NOT NULL,
  processed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_vcs_commits_integration_id ON vcs_commits(integration_id);
CREATE INDEX idx_vcs_commits_task_id ON vcs_commits(task_id);
CREATE INDEX idx_vcs_commits_committed_at ON vcs_commits(committed_at DESC);

-- Pull requests table
CREATE TABLE vcs_pull_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  integration_id UUID NOT NULL REFERENCES vcs_integrations(id) ON DELETE CASCADE,
  task_id UUID NOT NULL REFERENCES issues(id),
  pr_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  author_name TEXT NOT NULL,
  source_branch TEXT NOT NULL,
  target_branch TEXT NOT NULL,
  state vcs_pr_state NOT NULL DEFAULT 'open',
  opened_at TIMESTAMPTZ NOT NULL,
  merged_at TIMESTAMPTZ,
  closed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_vcs_pull_requests_integration_id ON vcs_pull_requests(integration_id);
CREATE INDEX idx_vcs_pull_requests_task_id ON vcs_pull_requests(task_id);
CREATE INDEX idx_vcs_pull_requests_state ON vcs_pull_requests(state);

-- RLS Policies
ALTER TABLE vcs_integrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE vcs_user_mappings ENABLE ROW LEVEL SECURITY;
ALTER TABLE vcs_commits ENABLE ROW LEVEL SECURITY;
ALTER TABLE vcs_pull_requests ENABLE ROW LEVEL SECURITY;

-- VCS Integrations: project members can read, admins can write
CREATE POLICY "vcs_integrations_select" ON vcs_integrations
  FOR SELECT USING (
    project_id IN (SELECT project_id FROM project_members WHERE user_id = auth.uid())
  );

CREATE POLICY "vcs_integrations_insert" ON vcs_integrations
  FOR INSERT WITH CHECK (
    project_id IN (
      SELECT project_id FROM project_members
      WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
    )
  );

CREATE POLICY "vcs_integrations_update" ON vcs_integrations
  FOR UPDATE USING (
    project_id IN (
      SELECT project_id FROM project_members
      WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
    )
  );

CREATE POLICY "vcs_integrations_delete" ON vcs_integrations
  FOR DELETE USING (
    project_id IN (
      SELECT project_id FROM project_members
      WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
    )
  );

-- VcsUserMappings: inherits from integration access
CREATE POLICY "vcs_user_mappings_select" ON vcs_user_mappings
  FOR SELECT USING (
    integration_id IN (SELECT id FROM vcs_integrations WHERE true)
  );

CREATE POLICY "vcs_user_mappings_insert" ON vcs_user_mappings
  FOR INSERT WITH CHECK (
    integration_id IN (SELECT id FROM vcs_integrations WHERE true)
  );

CREATE POLICY "vcs_user_mappings_delete" ON vcs_user_mappings
  FOR DELETE USING (
    integration_id IN (SELECT id FROM vcs_integrations WHERE true)
  );

-- VcsCommits: read access for users who can see the task
CREATE POLICY "vcs_commits_select" ON vcs_commits
  FOR SELECT USING (
    task_id IN (SELECT id FROM issues WHERE true)
  );

CREATE POLICY "vcs_commits_insert" ON vcs_commits
  FOR INSERT WITH CHECK (true);

-- VcsPullRequests: same as commits
CREATE POLICY "vcs_pull_requests_select" ON vcs_pull_requests
  FOR SELECT USING (
    task_id IN (SELECT id FROM issues WHERE true)
  );

CREATE POLICY "vcs_pull_requests_insert" ON vcs_pull_requests
  FOR INSERT WITH CHECK (true);

CREATE POLICY "vcs_pull_requests_update" ON vcs_pull_requests
  FOR UPDATE USING (true);
