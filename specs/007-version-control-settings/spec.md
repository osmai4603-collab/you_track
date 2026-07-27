# Feature Specification: Version Control Settings

**Feature Branch**: `007-version-control-settings`

**Created**: 2026-07-26

**Status**: Draft

**Input**: User description: "Add Version Control settings page to the project settings, enabling repository integrations (GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, Gitea, Custom Git) with conditional authentication fields (OAuth/Token/SSH), commit parsing, PR automation, visibility controls, user mapping, and synchronization settings — following YouTrack's VCS integration design with full data model and conditional field logic."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Connected Repositories Table (Priority: P1)

As a project administrator, I want to view all connected repositories in a structured table so that I can manage VCS integrations for the project.

**Why this priority**: The repository list is the foundational view for all VCS management. Without it, users cannot see or manage their integrations.

**Actor Constraint**: Only project owners and administrators can access the Version Control settings page and perform management actions (add, edit, disable, delete). All project members can view the resulting VCS Changes tab in tasks, subject to the "Visible to" group restriction.

**Independent Test**: Navigate to Version Control settings and verify all connected repositories display in a table with correct columns and status indicators.

**Acceptance Scenarios**:

1. **Given** the user is on the Version Control settings page, **When** repositories are connected, **Then** a table displays with columns: repository name & logo, service type, watched branches, connection status, and actions
2. **Given** the user is on the Version Control settings page, **When** no repositories are connected, **Then** an empty state message is displayed with a "Connect to Repository" call-to-action
3. **Given** the user views the repository table, **When** hovering over a row, **Then** the row elevates visually and quick action buttons appear (edit, disable/enable, delete)

---

### User Story 2 - Add New Repository Connection (Priority: P1)

As a project administrator, I want to connect a new VCS repository through a step-by-step flow with conditional fields that adapt to my chosen provider and authentication mode, so that I can integrate our codebase with the project.

**Why this priority**: Adding repositories is the primary entry point for the entire VCS feature. The conditional field logic ensures users only see relevant inputs, reducing confusion and errors.

**Independent Test**: Click "Connect to Repository", complete the multi-step flow (provider selection → authentication → mapping → save), verify conditional fields appear/hide correctly based on provider and auth mode, and verify the repository appears in the table.

**Acceptance Scenarios**:

1. **Given** the user clicks "Connect to Repository", **When** the add dialog opens, **Then** a card grid displays provider options: GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, Gitea, Custom Git
2. **Given** the user selects a cloud provider (GitHub, GitLab, Bitbucket Cloud), **When** the form renders, **Then** the Server URL field is hidden (NULL) and OAuth 2.0 button is the primary auth option
3. **Given** the user selects a self-hosted provider (Bitbucket Server, Gitea, Custom Git), **When** the form renders, **Then** the Server URL field becomes required and visible
4. **Given** the user selects "Token" as auth mode, **When** the auth fields render, **Then** the Personal Access Token field is required and the SSH Private Key fields are hidden
5. **Given** the user selects "SSH Key" as auth mode, **When** the auth fields render, **Then** the SSH Private Key text area and optional Passphrase field are required and the Token field is hidden
6. **Given** the user completes authentication, **When** the connection is verified, **Then** organization/repository dropdowns populate dynamically from the remote API
7. **Given** the user fills all required fields, **When** validation passes, **Then** the "Save" button becomes enabled
8. **Given** the user clicks "Test Connection", **When** the test is in progress, **Then** a loading spinner appears and the result is displayed (success/failure with snackbar)

---

### User Story 3 - Configure Commit Parsing for Commands (Priority: P1)

As a project administrator, I want to enable commit message parsing and conditionally configure which user groups can execute commands, so that YouTrack automatically updates task status from commit messages while maintaining security.

**Why this priority**: Commit parsing is the core automation that links code changes to task management. The conditional group field ensures the command executors list is only relevant when parsing is active.

**Independent Test**: Enable commit parsing, verify the command executors group field appears; disable it, verify the field disappears and the stored groups are cleared; push a commit with a command and verify the task is updated.

**Acceptance Scenarios**:

1. **Given** the user opens repository settings, **When** "Parse commits for commands" is toggled ON, **Then** a collapsible section appears with a multi-select field for "Command Executors Groups"
2. **Given** "Parse commits for commands" is toggled OFF, **When** the form updates, **Then** the command executors groups field is hidden and any stored group UUIDs are cleared
3. **Given** commit parsing is enabled with specific groups assigned, **When** a developer pushes a commit with "DEMO-101 #Fixed", **Then** the task DEMO-101 transitions to the "Fixed" state only if the committer belongs to an authorized group
4. **Given** commit parsing is enabled, **When** a commit contains "@username", **Then** the referenced user is assigned to the task
5. **Given** commit parsing is enabled, **When** a committer is NOT in any authorized group, **Then** the commit is ignored for command processing (no task updates)

---

### User Story 4 - Configure Pull Request Automation (Priority: P1)

As a project administrator, I want to enable PR automation so that tasks automatically transition to "In Review" when a PR is opened and to "Merged/Fixed" when it is merged.

**Why this priority**: PR automation eliminates manual status updates during the code review workflow, directly improving team velocity.

**PR-to-Task Linking**: The system auto-parses the PR title and description for task IDs using the same pattern as commit messages (e.g., "DEMO-101 Fix login bug"). The first recognized task ID found becomes the linked task. This is consistent with commit parsing and requires no additional developer action beyond including the task ID in the PR title.

**Independent Test**: Open a PR linked to a task, verify it moves to "In Review"; merge the PR, verify it moves to "Merged/Fixed".

**Acceptance Scenarios**:

1. **Given** PR automation is enabled, **When** a pull request is opened referencing a task, **Then** the task transitions to "In Review" state
2. **Given** PR automation is enabled, **When** a pull request is merged, **Then** the linked task transitions to "Merged" or "Fixed" state
3. **Given** PR automation is enabled, **When** a pull request is closed without merging, **Then** the task reverts to its previous state

---

### User Story 5 - Control Repository Visibility & User Mapping (Priority: P2)

As a project administrator, I want to control who can see VCS changes in tasks and configure both automatic and manual user mapping, so that sensitive code information is restricted and commits are attributed to the correct team members.

**Why this priority**: Visibility control is essential for projects with external clients or mixed teams. Accurate user mapping ensures accountability and traceability in commit history.

**Independent Test**: Set visibility to a specific group via UUID selector, verify members outside that group cannot see VCS Changes tab; configure auto user mapping, verify commits are attributed correctly; add manual mapping override, verify it takes precedence.

**Acceptance Scenarios**:

1. **Given** the user opens visibility settings, **When** "Visible to" is configured, **Then** a group selector accepts UUID references and displays available project groups/roles
2. **Given** visibility is set to specific group UUIDs, **When** a user outside those groups views a task, **Then** the "VCS Changes" tab is hidden
3. **Given** "Automatic User Mapping" is enabled, **When** a developer's VCS email matches a YouTrack account email, **Then** commits are attributed to the correct user automatically
4. **Given** the user adds a manual mapping entry, **When** the VCS username or email is entered with a target YouTrack user ID, **Then** the manual mapping overrides automatic matching for that entry
5. **Given** both automatic and manual mappings exist, **When** a commit arrives, **Then** manual mapping takes precedence over automatic matching

---

### User Story 6 - Manage Connection Status & Actions (Priority: P2)

As a project administrator, I want to see connection health indicators and perform quick actions (enable, disable, delete) so that I can maintain integrations without navigating away from the list.

**Why this priority**: Quick status visibility and actions reduce maintenance overhead for administrators managing multiple repositories.

**Independent Test**: Verify status badges show correct colors; disable a repository and verify it stops syncing; re-enable and verify syncing resumes.

**Acceptance Scenarios**:

1. **Given** a repository is connected and active, **When** viewing the table, **Then** a green status badge (pill) indicates "Connected"
2. **Given** a repository has an expired token, **When** viewing the table, **Then** a red status badge with an exclamation icon indicates "Authentication Failed"
3. **Given** a repository is disabled, **When** viewing the table, **Then** a gray status badge indicates "Disabled"
4. **Given** the user clicks the disable action on a repository, **When** the action completes, **Then** the repository stops syncing but settings are preserved
5. **Given** the user clicks the enable action on a disabled repository, **When** the action completes, **Then** syncing resumes with existing settings

---

### User Story 7 - Configure Synchronization Settings (Priority: P2)

As a project administrator, I want to configure sync behavior (silent processing, branch specification) so that the integration matches our team's workflow.

**Why this priority**: Sync settings prevent notification spam and ensure only relevant branches are monitored, improving developer experience.

**Independent Test**: Enable silent processing, push commits, and verify no email notifications are sent; set branch specification and verify only matching branches trigger updates.

**Acceptance Scenarios**:

1. **Given** "Silent Processing" is enabled, **When** commits are pushed, **Then** task updates occur without sending email notifications to project members
2. **Given** "Silent Processing" is disabled, **When** commits are pushed, **Then** email notifications are sent for each task update
3. **Given** branch specification is set to "main, develop", **When** commits are pushed to other branches, **Then** no task updates occur
4. **Given** branch specification is set to "main, develop", **When** commits are pushed to "main" or "develop", **Then** tasks are updated normally

---

### Edge Cases

- What happens when OAuth token expires mid-session? (Show red status badge and prompt re-authentication on next action)
- What happens when a repository is deleted on the remote platform? (Show "Authentication Failed" status; manual reconnection required)
- What happens when two administrators modify the same repository settings simultaneously? (Last-write-wins with confirmation)
- What happens when the VCS provider API is temporarily unavailable? (Retry 3x with exponential backoff — 1s, 5s, 15s delays; if all retries fail, mark integration as "Sync Error" status and alert admin via notification)
- What happens when a commit references a non-existent task ID? (Ignore the command, log a warning internally)
- What happens when user mapping finds multiple matching email addresses? (Use the first active match; warn if ambiguous)
- What happens when the user switches auth_mode from token to ssh after entering a token? (Clear the token field, show SSH fields, enforce mutual exclusion)
- What happens when the user switches from a self-hosted provider to a cloud provider? (Clear server_url, hide the field, re-render auth options)
- What happens when parse_commits_for_commands is toggled OFF after groups are selected? (Clear command_executors_groups array, hide the collapsible section)
- What happens when a manual user mapping entry conflicts with an automatic match? (Manual mapping takes precedence; show visual indicator for overridden entries)
- What happens when a VCS webhook delivery fails or is delayed? (Queue for retry with exponential backoff; mark "Sync Error" after 3 failed attempts)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display connected repositories in a table with columns: repository name & logo, service type, watched branches, connection status, and actions
- **FR-002**: System MUST provide a "Connect to Repository" button that opens a multi-step add dialog
- **FR-003**: System MUST display provider selection as a card grid with logos: GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, Gitea, Custom Git
- **FR-004**: System MUST render authentication fields dynamically based on selected provider and auth mode
- **FR-005**: System MUST support OAuth 2.0 authentication for GitHub, GitLab, and Bitbucket Cloud
- **FR-006**: System MUST support Personal Access Token authentication as an alternative for cloud providers and primary for self-hosted
- **FR-007**: System MUST support SSH Key authentication for Custom Git and self-hosted providers, with optional Passphrase field
- **FR-008**: System MUST enforce mutual exclusion between Token and SSH Key fields based on selected auth_mode (token vs ssh)
- **FR-009**: System MUST show Server URL field as required ONLY when provider is Bitbucket Server, Gitea, or Custom Git; hide it for GitHub, GitLab, Bitbucket Cloud
- **FR-010**: System MUST provide a "Test Connection" button that validates credentials before saving
- **FR-011**: System MUST populate organization and repository dropdowns dynamically after successful authentication
- **FR-012**: System MUST provide a tokenized input field for branch specification with default value "+:* " (all branches) or "+:refs/heads/main" (single branch)
- **FR-013**: System MUST provide toggle switches for: "Parse commits for commands", "Enable Silent Processing", "Pull Request Automation", "Automatic User Mapping"
- **FR-014**: System MUST display a collapsible section for Command Executors Groups ONLY when "Parse commits for commands" is enabled; clear stored groups when disabled
- **FR-015**: System MUST parse commit messages for task references (e.g., "DEMO-101") and execute commands (e.g., "#Fixed", "Assignee @username")
- **FR-016**: System MUST transition tasks to "In Review" when linked PRs are opened (when PR automation is enabled)
- **FR-017**: System MUST transition tasks to "Merged/Fixed" when linked PRs are merged (when PR automation is enabled)
- **FR-017a**: System MUST auto-parse PR title and description for task IDs using the same pattern as commit messages; the first recognized task ID found becomes the linked task
- **FR-018**: System MUST provide a "Visible to" group/role selector using UUID array to restrict VCS Changes tab visibility
- **FR-019**: System MUST support automatic user mapping by matching VCS commit email to YouTrack account email
- **FR-020**: System MUST support manual user mapping entries (VCS email/username → YouTrack user UUID) that override automatic matching
- **FR-021**: System MUST display status badges: green (Connected), gray (Disabled), red with icon (Authentication Failed), yellow with icon (Sync Error — after 3 consecutive API failures)
- **FR-021a**: System MUST retry failed VCS API calls 3 times with exponential backoff (1s, 5s, 15s delays) before marking integration as "Sync Error"
- **FR-022**: System MUST support disable/enable toggle per repository without deleting settings
- **FR-023**: System MUST provide a sticky bottom action bar with "Test Connection", "Save" (disabled until valid), and "Cancel" buttons
- **FR-024**: System MUST validate that all required fields are filled before enabling the "Save" button
- **FR-025**: System MUST support horizontal scrolling for the repository table on small screens
- **FR-026**: System MUST show row elevation and quick action buttons on hover in the repository table
- **FR-027**: System MUST preserve repository settings when the connection is disabled
- **FR-028**: System MUST notify the user with a snackbar when connection tests succeed or fail
- **FR-029**: System MUST validate branch specification against valid git ref patterns
- **FR-030**: System MUST restrict VCS settings page access to project owners and administrators only; non-admin members must not see or access the Version Control configuration
- **FR-031**: System MUST store the following fields per integration: id (UUID), project_id (UUID), integration_name, provider_type (enum), server_url (nullable), auth_mode (enum), encrypted_token (nullable), ssh_private_key (nullable), passphrase (nullable), organization_owner, repository_name, branch_specification, parse_commits_for_commands (boolean), silent_processing (boolean), pull_request_automation (boolean), command_executors_groups (UUID array, nullable), visible_to_roles (UUID array), automatic_user_mapping (boolean)
- **FR-032**: System MUST store manual user mapping entries in a separate table: integration_id (UUID), vcs_username_or_email, youtrack_user_id (UUID)
- **FR-033**: System MUST ensure encrypted_token and ssh_private_key are mutually exclusive based on auth_mode; only one set is populated at a time
- **FR-033a**: System MUST encrypt all sensitive credentials (encrypted_token, ssh_private_key, passphrase) at rest using application-level encryption with a project-scoped encryption key managed via environment variable or secrets manager; credentials MUST NOT be stored in plaintext
- **FR-034**: System MUST persistently store commit records (VcsCommit) with: commit_sha, author info, message, timestamp, branch, and linked task_id for VCS Changes tab history
- **FR-035**: System MUST persistently store pull request records (VcsPullRequest) with: PR number, title, author, branches, state, and timestamps for automation tracking
- **FR-036**: System MUST display stored commit and PR history in the VCS Changes tab of linked tasks, ordered by most recent first

### Key Entities

- **VcsIntegration**: Core entity representing a connected repository. Fields: id (UUID), project_id (UUID), integration_name (text), provider_type (enum: github/gitlab/bitbucket_cloud/bitbucket_server/gitea/custom_git), server_url (text, nullable — required only for self-hosted providers), auth_mode (enum: oauth/token/ssh), encrypted_token (text, nullable — populated when auth_mode=token), ssh_private_key (text, nullable — populated when auth_mode=ssh), passphrase (text, nullable — optional SSH passphrase), organization_owner (text), repository_name (text), branch_specification (text, default "+:*"), parse_commits_for_commands (boolean), silent_processing (boolean), pull_request_automation (boolean), command_executors_groups (UUID array, nullable — cleared when parse_commits=false), visible_to_roles (UUID array), automatic_user_mapping (boolean)
- **VcsUserMapping**: Manual email/username override for user attribution. Fields: integration_id (UUID FK), vcs_username_or_email (text), youtrack_user_id (UUID FK). Takes precedence over automatic email matching.
- **VcsProvider**: The VCS service type configuration with associated OAuth endpoints, API base URLs, and field requirements (GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, Gitea, Custom Git)
- **CommitCommand**: A parsed command extracted from a commit message. Fields: taskId (text), commandType (enum: state/assignee/priority), value (text), rawText (text)
- **VcsCommit**: Persisted commit record for VCS Changes tab history and audit. Fields: id (UUID), integration_id (UUID FK), task_id (UUID FK), commit_sha (text), author_name (text), author_email (text), message (text), committed_at (datetime), branch (text), processed_at (datetime)
- **VcsPullRequest**: Persisted PR record for automation tracking and history. Fields: id (UUID), integration_id (UUID FK), task_id (UUID FK), pr_number (integer), title (text), author_name (text), source_branch (text), target_branch (text), state (enum: open/merged/closed), opened_at (datetime), merged_at (datetime, nullable), closed_at (datetime, nullable)
- **PrAutomation**: Pull request automation rules. Fields: onOpenTransition (state), onMergeTransition (state), onClosedRevert (boolean)
- **RepositoryVisibility**: Controls VCS Changes tab access via visible_to_roles (UUID array referencing project groups/roles)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can connect a new repository in under 3 minutes from clicking "Connect to Repository"
- **SC-002**: Connection test results are displayed within 5 seconds of clicking "Test Connection"
- **SC-003**: Repository table loads and displays all connected repositories within 2 seconds
- **SC-004**: All toolbar actions (edit, disable, delete) are accessible within 2 clicks from the main view
- **SC-005**: Commit parsing correctly identifies and executes commands for 95% of valid commit message formats
- **SC-006**: PR automation transitions tasks within 30 seconds of webhook event processing (from the moment the system receives and validates the PR webhook payload)
- **SC-007**: Silent processing successfully suppresses email notifications for 100% of sync events when enabled
- **SC-008**: The add repository dialog adapts authentication fields to the selected provider within 1 second

## Assumptions

- The existing project settings navigation already includes a "Version Control" tab or the tab will be added as part of this feature
- OAuth 2.0 credentials (client IDs) for GitHub, GitLab, and Bitbucket Cloud will be configured at the application level, not per-project
- The project already has a user/group management system with UUID-based group/role identifiers that can be leveraged for visibility controls
- Commit message format follows standard conventions (task ID prefix, #command syntax, @mention syntax)
- The system has access to VCS provider webhooks for real-time PR event notifications
- Branch specification uses standard git ref patterns (refs/heads/branch-name); default value is "+:*" for all branches
- Email-based automatic user mapping is the primary method; manual mapping overrides are available for edge cases
- The UI follows the existing project settings page patterns (table layout, toolbar, dialogs)
- Database schema includes four tables: `vcs_integrations`, `vcs_user_mappings`, `vcs_commits`, `vcs_pull_requests`
- encrypted_token and ssh_private_key are mutually exclusive — only one is populated based on auth_mode
- Sensitive credentials (tokens, SSH keys, passphrases) are encrypted at rest via application-level encryption with a project-scoped key
- server_url is conditionally required: NULL for github/gitlab/bitbucket_cloud, required for bitbucket_server/gitea/custom_git
- command_executors_groups array is cleared and ignored when parse_commits_for_commands is false
- The feature is scoped to project-level settings (organization-wide VCS settings are out of scope)
- Gitea support follows the same pattern as Custom Git (self-hosted with server URL and token/SSH auth)

## Clarifications

### Session 2026-07-26 (Initial)

- Q: Should the "Custom Git" provider support SSH URLs or only HTTPS? → A: HTTPS only for this version (SSH key management is out of scope) — **REVISED**: SSH Key auth mode now supported for self-hosted providers
- Q: How many repositories can be connected per project? → A: No hard limit in this version; performance tested up to 10 repositories
- Q: Should commit parsing support custom commands beyond the default set (#Fixed, #In Progress, etc.)? → A: Yes, support custom commands configured via the collapsible section in repository settings

### Session 2026-07-26 (Data Model Additions)

- Q: What are the conditional field rules for server_url? → A: Server URL is NULL for github/gitlab/bitbucket_cloud; required (text field) for bitbucket_server/gitea/custom_git
- Q: How do encrypted_token and ssh_private_key coexist? → A: Mutual exclusion controlled by auth_mode; if auth_mode='token' then encrypted_token is required; if auth_mode='ssh' then ssh_private_key takes over
- Q: What happens to command_executors_groups when parsing is disabled? → A: The array is completely ignored or cleared when parse_commits_for_commands is false
- Q: What provider types are supported? → A: GitHub, GitLab, Bitbucket Cloud, Bitbucket Server, Gitea, Custom Git (Self-Hosted)
- Q: What authentication modes are available? → A: OAuth 2.0 (cloud providers), Token (Personal Access Token), SSH Key (with optional passphrase for self-hosted)
- Q: How is user mapping structured? → A: Automatic mapping via email match (boolean toggle) + manual override table (vcs_user_mappings) with precedence over automatic

### Session 2026-07-26 (Clarification Round 1)

- Q: Who can manage VCS integrations vs. who can view VCS Changes? → A: Only project owners/admins can manage VCS integrations; all project members can view VCS Changes tab (subject to Visible To group restrictions)
- Q: Should the system store commit/PR history or only process events in real-time? → A: Store commit and PR data persistently — enables VCS Changes tab history, audit trail, and re-processing capability
- Q: How should the system detect which task a pull request is linked to? → A: Auto-parse PR title and description for task IDs using the same pattern as commit messages (first recognized task ID becomes the linked task)
- Q: How should the system handle VCS provider API failures during automated background sync? → A: Retry 3x with exponential backoff (1s, 5s, 15s delays); if all retries fail, mark integration as "Sync Error" and alert admin via notification
- Q: How should sensitive VCS credentials (tokens, SSH keys, passphrases) be encrypted in the database? → A: Application-level encryption using a project-scoped encryption key managed via environment variable or secrets manager; credentials never stored in plaintext
