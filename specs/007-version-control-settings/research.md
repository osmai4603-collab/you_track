# Research: Version Control Settings

**Feature**: 007-version-control-settings
**Date**: 2026-07-26

## Research Topics

### 1. VCS Provider API Integration Patterns

**Decision**: Use HTTP REST APIs for each VCS provider with a unified adapter interface.

**Rationale**: Each provider (GitHub, GitLab, Bitbucket, Gitea) exposes REST APIs for listing organizations, repositories, and validating credentials. A common `VcsProviderAdapter` interface abstracts provider-specific differences.

**Alternatives considered**:
- OAuth-only integration: Rejected — doesn't support self-hosted providers or SSH auth
- Using `github` package: Rejected — only covers GitHub, not other providers
- Direct HTTP calls in repository: Rejected — violates Clean Architecture (data source layer should handle API calls)

**Provider API Endpoints**:
| Provider | Auth Validation | Org/Repo Listing |
|----------|----------------|------------------|
| GitHub | `GET /user` | `GET /user/orgs`, `GET /orgs/{org}/repos` |
| GitLab | `GET /api/v4/user` | `GET /api/v4/groups`, `GET /api/v4/groups/{id}/projects` |
| Bitbucket Cloud | `GET /2.0/user` | `GET /2.0/workspaces`, `GET /2.0/repositories/{workspace}` |
| Bitbucket Server | `GET /rest/api/1.0/users` | `GET /rest/api/1.0/projects` |
| Gitea | `GET /api/v1/user` | `GET /api/v1/orgs`, `GET /api/v1/orgs/{org}/repos` |
| Custom Git | N/A (token validated on clone) | N/A (manual entry) |

### 2. Credential Encryption Strategy

**Decision**: Application-level AES-256-GCM encryption using `dart:crypto` with a project-scoped key from environment variable.

**Rationale**: Matches spec requirement (FR-033a). Supabase doesn't provide column-level encryption natively. App-level encryption ensures credentials are never stored in plaintext and are only decryptable by the application.

**Alternatives considered**:
- Supabase Vault: Rejected — requires Supabase Pro plan, adds external dependency
- Simple Base64 encoding: Rejected — not encryption, easily reversible
- Flutter `encrypt` package: Considered — but `dart:crypto` is sufficient for AES-GCM

**Implementation Pattern**:
```dart
// Encrypt before Supabase insert
final encrypted = encrypt(plaintext, key: projectScopedKey);
// Decrypt after Supabase fetch
final decrypted = decrypt(encryptedData, key: projectScopedKey);
```

### 3. Conditional Field Rendering in Forms

**Decision**: State-driven form builder pattern using Cubit-managed form state.

**Rationale**: The add dialog has complex conditional field logic (provider → auth mode → field visibility). A `VcsIntegrationFormCubit` manages the form state including selected provider, auth mode, and computed field visibility flags. The UI reactively renders fields based on cubit state.

**Alternatives considered**:
- Multi-step wizard: Rejected — adds navigation complexity, spec shows single-page dialog
- Static form with hidden fields: Rejected — harder to maintain, validation issues
- Third-party form builder: Rejected — project uses manual form construction

### 4. Branch Specification Input Pattern

**Decision**: Tokenized text input using `Chip` + `TextField` pattern (similar to email input in modern forms).

**Rationale**: Spec requires "tokenized input field" (FR-012). Users type branch patterns and press Enter/comma to create tokens. Tokens can be individually removed. Default value "+:*" (all branches).

**Alternatives considered**:
- Simple TextField with comma-separated values: Rejected — spec requires tokenized input
- Multi-select dropdown from available branches: Rejected — requires API call to list branches, adds complexity
- Chip-based input with autocomplete: Considered for future enhancement

### 5. Webhook vs Polling for PR Events

**Decision**: Webhook-based with polling fallback for initial implementation.

**Rationale**: Spec assumes "access to VCS provider webhooks" (Assumptions). Webhooks provide real-time PR event notifications. Polling fallback ensures reliability when webhook setup fails.

**Alternatives considered**:
- Polling only: Rejected — doesn't meet SC-006 (30s transition target)
- Webhooks only: Rejected — requires public URL for webhook delivery, not always available
- Webhook + retry queue: Selected — handles transient failures per FR-021a

### 6. Commit Message Parsing Strategy

**Decision**: Regex-based parser with configurable command patterns.

**Rationale**: Spec defines commit format: `TASK-ID #Command @username`. Standard regex pattern: `([A-Z]+-\d+)\s+#(\w+)\s+@(\w+)`. Parser extracts task ID, command, and assignee from commit messages.

**Alternatives considered**:
- NLP-based parsing: Rejected — overkill for structured format
- Configurable YAML-based rules: Considered for future, but regex sufficient for initial version
- Third-party commit parser: Rejected — no suitable Dart package exists

### 7. State Management for VCS Feature

**Decision**: Cubit-based (matching project convention) with 4 cubits.

**Rationale**: Project predominantly uses Cubit pattern. VCS feature has 4 distinct state domains:
1. `VcsIntegrationsCubit` — list of integrations, CRUD operations
2. `VcsIntegrationFormCubit` — add/edit form state, conditional fields, validation
3. `VcsUserMappingsCubit` — manual user mapping entries
4. `VcsConnectionTestCubit` — connection test state (loading/success/failure)

**Alternatives considered**:
- Single monolithic cubit: Rejected — too many responsibilities
- BLoC with events: Rejected — cubit is simpler and matches project pattern for settings pages

### 8. Database Migration Strategy

**Decision**: Supabase SQL migrations via `supabase/migrations/` directory.

**Rationale**: Project uses Supabase. Migrations are versioned SQL files. New tables created in a single migration file for the VCS feature.

**Tables to create**:
1. `vcs_integrations` — main configuration
2. `vcs_user_mappings` — manual user overrides
3. `vcs_commits` — commit history
4. `vcs_pull_requests` — PR history

**RLS policies**: Admin-only access for CRUD on `vcs_integrations` and `vcs_user_mappings`. Read access for `vcs_commits` and `vcs_pull_requests` subject to `visible_to_roles`.
