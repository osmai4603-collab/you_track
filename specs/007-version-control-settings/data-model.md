# Data Model: Version Control Settings

**Feature**: 007-version-control-settings
**Date**: 2026-07-26

## Entity Relationship Diagram

```
┌──────────────────┐       ┌──────────────────┐
│  vcs_integrations │──1:N──│  vcs_user_mappings│
└──────────────────┘       └──────────────────┘
        │
        │ 1:N
        ▼
┌──────────────────┐       ┌──────────────────┐
│   vcs_commits    │       │ vcs_pull_requests │
└──────────────────┘       └──────────────────┘
```

## Entities

### 1. VcsIntegration (Core Entity)

**Table**: `vcs_integrations`
**Purpose**: Stores configuration for each connected VCS repository

| Field | Type | Nullable | Default | Constraints | Description |
|-------|------|----------|---------|-------------|-------------|
| id | UUID | No | gen_random_uuid() | PK | Unique integration identifier |
| project_id | UUID | No | — | FK → projects.id | owning project |
| integration_name | TEXT | No | — | NOT NULL | User-defined name for this connection |
| provider_type | TEXT | No | — | CHECK (provider_type IN ('github','gitlab','bitbucket_cloud','bitbucket_server','gitea','custom_git')) | VCS platform type |
| server_url | TEXT | Yes | NULL | — | Required only for self-hosted providers |
| auth_mode | TEXT | No | — | CHECK (auth_mode IN ('oauth','token','ssh')) | Authentication method |
| encrypted_token | TEXT | Yes | NULL | — | Encrypted PAT (when auth_mode='token') |
| ssh_private_key | TEXT | Yes | NULL | — | Encrypted SSH key (when auth_mode='ssh') |
| passphrase | TEXT | Yes | NULL | — | Encrypted SSH passphrase (optional) |
| organization_owner | TEXT | No | — | — | GitHub org / GitLab group / Bitbucket workspace |
| repository_name | TEXT | No | — | — | Target repository name |
| branch_specification | TEXT | No | '+:*' | — | Git ref patterns to watch |
| parse_commits_for_commands | BOOLEAN | No | false | — | Enable commit message parsing |
| silent_processing | BOOLEAN | No | false | — | Suppress email notifications |
| pull_request_automation | BOOLEAN | No | false | — | Enable PR state transitions |
| command_executors_groups | UUID[] | Yes | NULL | — | Group UUIDs allowed to execute commands; NULL = all |
| visible_to_roles | UUID[] | No | '{}'::uuid[] | — | Group/role UUIDs that can see VCS Changes tab |
| automatic_user_mapping | BOOLEAN | No | true | — | Auto-match VCS email to YouTrack account |
| status | TEXT | No | 'connected' | CHECK (status IN ('connected','disabled','auth_failed','sync_error')) | Connection health status |
| created_at | TIMESTAMPTZ | No | now() | — | Record creation timestamp |
| updated_at | TIMESTAMPTZ | No | now() | — | Last modification timestamp |

**Indexes**:
- `idx_vcs_integrations_project_id` ON (project_id)
- `idx_vcs_integrations_status` ON (status)

**RLS Policies**:
- SELECT: Authenticated users where project_id IN (user's project memberships)
- INSERT/UPDATE/DELETE: Only project owners/admins

**Conditional Field Rules**:
- `server_url`: NULL for github/gitlab/bitbucket_cloud; required for bitbucket_server/gitea/custom_git
- `encrypted_token`: Populated when auth_mode='token'; NULL otherwise
- `ssh_private_key`: Populated when auth_mode='ssh'; NULL otherwise
- `command_executors_groups`: Cleared when parse_commits_for_commands=false

---

### 2. VcsUserMapping

**Table**: `vcs_user_mappings`
**Purpose**: Manual email/username overrides for user attribution

| Field | Type | Nullable | Default | Constraints | Description |
|-------|------|----------|---------|-------------|-------------|
| id | UUID | No | gen_random_uuid() | PK | Unique mapping identifier |
| integration_id | UUID | No | — | FK → vcs_integrations.id ON DELETE CASCADE | Parent integration |
| vcs_username_or_email | TEXT | No | — | NOT NULL | VCS author email or username |
| youtrack_user_id | UUID | No | — | FK → users.id | Target YouTrack user |
| created_at | TIMESTAMPTZ | No | now() | — | Record creation timestamp |

**Indexes**:
- `idx_vcs_user_mappings_integration_id` ON (integration_id)
- `idx_vcs_user_mappings_email` ON (vcs_username_or_email)

**RLS Policies**:
- Same as vcs_integrations (project-scoped)

**Business Rules**:
- Manual mapping takes precedence over automatic email matching
- Multiple mappings per integration allowed (different VCS emails → different users)

---

### 3. VcsCommit

**Table**: `vcs_commits`
**Purpose**: Persisted commit records for VCS Changes tab history and audit

| Field | Type | Nullable | Default | Constraints | Description |
|-------|------|----------|---------|-------------|-------------|
| id | UUID | No | gen_random_uuid() | PK | Unique commit record identifier |
| integration_id | UUID | No | — | FK → vcs_integrations.id ON DELETE CASCADE | Source integration |
| task_id | UUID | No | — | FK → issues.id | Linked task/issue |
| commit_sha | TEXT | No | — | NOT NULL | Full commit hash |
| author_name | TEXT | No | — | — | Git author name |
| author_email | TEXT | No | — | — | Git author email |
| message | TEXT | No | — | — | Full commit message |
| branch | TEXT | No | — | — | Branch name |
| committed_at | TIMESTAMPTZ | No | — | — | Git commit timestamp |
| processed_at | TIMESTAMPTZ | No | now() | — | When YouTrack processed this commit |

**Indexes**:
- `idx_vcs_commits_integration_id` ON (integration_id)
- `idx_vcs_commits_task_id` ON (task_id)
- `idx_vcs_commits_committed_at` ON (committed_at DESC)

**RLS Policies**:
- SELECT: Users who can see the linked task AND are in visible_to_roles for the integration
- INSERT: System only (webhook handler)

---

### 4. VcsPullRequest

**Table**: `vcs_pull_requests`
**Purpose**: Persisted PR records for automation tracking and history

| Field | Type | Nullable | Default | Constraints | Description |
|-------|------|----------|---------|-------------|-------------|
| id | UUID | No | gen_random_uuid() | PK | Unique PR record identifier |
| integration_id | UUID | No | — | FK → vcs_integrations.id ON DELETE CASCADE | Source integration |
| task_id | UUID | No | — | FK → issues.id | Linked task/issue |
| pr_number | INTEGER | No | — | NOT NULL | PR/MR number from VCS |
| title | TEXT | No | — | — | PR title |
| author_name | TEXT | No | — | — | PR author |
| source_branch | TEXT | No | — | — | Feature branch |
| target_branch | TEXT | No | — | — | Target branch (main/develop) |
| state | TEXT | No | — | CHECK (state IN ('open','merged','closed')) | Current PR state |
| opened_at | TIMESTAMPTZ | No | — | — | When PR was opened |
| merged_at | TIMESTAMPTZ | Yes | NULL | — | When PR was merged |
| closed_at | TIMESTAMPTZ | Yes | NULL | — | When PR was closed without merge |
| created_at | TIMESTAMPTZ | No | now() | — | Record creation timestamp |

**Indexes**:
- `idx_vcs_pull_requests_integration_id` ON (integration_id)
- `idx_vcs_pull_requests_task_id` ON (task_id)
- `idx_vcs_pull_requests_state` ON (state)

**RLS Policies**:
- Same as vcs_commits (task visibility + integration roles)

## Dart Entity Classes

### VcsIntegrationEntity

```dart
class VcsIntegrationEntity extends Entity {
  final String id;
  final String projectId;
  final String integrationName;
  final VcsProviderType providerType;
  final String? serverUrl;
  final VcsAuthMode authMode;
  final String? encryptedToken;
  final String? sshPrivateKey;
  final String? passphrase;
  final String organizationOwner;
  final String repositoryName;
  final String branchSpecification;
  final bool parseCommitsForCommands;
  final bool silentProcessing;
  final bool pullRequestAutomation;
  final List<String>? commandExecutorsGroups;
  final List<String> visibleToRoles;
  final bool automaticUserMapping;
  final VcsConnectionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### VcsUserMappingEntity

```dart
class VcsUserMappingEntity extends Entity {
  final String id;
  final String integrationId;
  final String vcsUsernameOrEmail;
  final String youtrackUserId;
  final DateTime createdAt;
}
```

### VcsCommitEntity

```dart
class VcsCommitEntity extends Entity {
  final String id;
  final String integrationId;
  final String taskId;
  final String commitSha;
  final String authorName;
  final String authorEmail;
  final String message;
  final String branch;
  final DateTime committedAt;
  final DateTime processedAt;
}
```

### VcsPullRequestEntity

```dart
class VcsPullRequestEntity extends Entity {
  final String id;
  final String integrationId;
  final String taskId;
  final int prNumber;
  final String title;
  final String authorName;
  final String sourceBranch;
  final String targetBranch;
  final VcsPrState state;
  final DateTime openedAt;
  final DateTime? mergedAt;
  final DateTime? closedAt;
  final DateTime createdAt;
}
```

## Enums

```dart
enum VcsProviderType {
  github,
  gitlab,
  bitbucketCloud,
  bitbucketServer,
  gitea,
  customGit,
}

enum VcsAuthMode {
  oauth,
  token,
  ssh,
}

enum VcsConnectionStatus {
  connected,
  disabled,
  authFailed,
  syncError,
}

enum VcsPrState {
  open,
  merged,
  closed,
}
```

## SQL Migration

```sql
-- Migration: 007_version_control_settings
-- Created: 2026-07-26

CREATE TYPE vcs_provider_type AS ENUM (
  'github', 'gitlab', 'bitbucket_cloud', 'bitbucket_server', 'gitea', 'custom_git'
);

CREATE TYPE vcs_auth_mode AS ENUM ('oauth', 'token', 'ssh');

CREATE TYPE vcs_connection_status AS ENUM (
  'connected', 'disabled', 'auth_failed', 'sync_error'
);

CREATE TYPE vcs_pr_state AS ENUM ('open', 'merged', 'closed');

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

CREATE TABLE vcs_user_mappings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  integration_id UUID NOT NULL REFERENCES vcs_integrations(id) ON DELETE CASCADE,
  vcs_username_or_email TEXT NOT NULL,
  youtrack_user_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_vcs_user_mappings_integration_id ON vcs_user_mappings(integration_id);
CREATE INDEX idx_vcs_user_mappings_email ON vcs_user_mappings(vcs_username_or_email);

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
  FOR INSERT WITH CHECK (true); -- System/webhook only

-- VcsPullRequests: same as commits
CREATE POLICY "vcs_pull_requests_select" ON vcs_pull_requests
  FOR SELECT USING (
    task_id IN (SELECT id FROM issues WHERE true)
  );

CREATE POLICY "vcs_pull_requests_insert" ON vcs_pull_requests
  FOR INSERT WITH CHECK (true);

CREATE POLICY "vcs_pull_requests_update" ON vcs_pull_requests
  FOR UPDATE USING (true);
```
