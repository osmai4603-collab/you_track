# UI Contract: Version Control Settings

**Feature**: 007-version-control-settings
**Date**: 2026-07-26

## Pages & Navigation

### Route
- **Path**: `/projects/:projectId/settings/vcs`
- **Route Key**: `AppRouteKeys.projectSettingsVersionControl` = `'vcs'`
- **Parent**: `ProjectSettingsPage` (index 3 in sidebar)
- **Access**: Admin/Owner only (non-admin sees 403 or hidden from sidebar)

### Page Structure
```
VcsSettingsPage
├── BlocConsumer<VcsIntegrationsCubit, VcsIntegrationsState>
│   ├── Loading State → CircularProgressIndicator
│   ├── Error State → ErrorView with retry button
│   ├── Empty State → EmptyStateView with "Connect to Repository" CTA
│   └── Loaded State → VcsRepositoryTable + Add Button
└── VcsAddDialog (modal overlay)
```

---

## Widget Contracts

### 1. VcsRepositoryTable

**Purpose**: Display all connected repositories in a data table

**Props/State**:
- `List<VcsIntegrationEntity> integrations`
- `Function(String id) onEdit`
- `Function(String id) onToggleStatus`
- `Function(String id) onDelete`

**Layout**:
```
┌──────────────────────────────────────────────────────────────────────┐
│ [+ Connect to Repository]                          [Search] [Refresh]│
├──────────────────────────────────────────────────────────────────────┤
│ ☐ │ Repository    │ Service │ Branches      │ Status  │ Actions     │
├──────────────────────────────────────────────────────────────────────┤
│ ☐ │ my-org/backend│ GitHub  │ main, develop │ ● Green │ ⚙️ 🔄 🗑️   │
│ ☐ │ my-org/frontend│ GitLab │ +:*           │ ● Green │ ⚙️ 🔄 🗑️   │
│ ☐ │ internal/srv  │ Gitea   │ main          │ ● Gray  │ ⚙️ 🔄 🗑️   │
└──────────────────────────────────────────────────────────────────────┘
```

**Row Hover Behavior**:
- Row elevation increases (shadow)
- Action buttons appear (Edit, Toggle, Delete)

**Columns**:
| Column | Flex | Content |
|--------|------|---------|
| Checkbox | 1 | Select-all / individual |
| Repository | 4 | Logo (16px) + integration_name |
| Service | 2 | provider_type as text chip |
| Branches | 3 | branch_specification (truncated) |
| Status | 2 | VcsStatusBadge component |
| Actions | 2 | IconButton trio (edit, toggle, delete) |

---

### 2. VcsStatusBadge

**Purpose**: Visual indicator of connection health

**States**:
| Status | Color | Icon | Text |
|--------|-------|------|------|
| connected | Green | check_circle | Connected |
| disabled | Gray | pause_circle | Disabled |
| auth_failed | Red | error | Auth Failed |
| sync_error | Yellow | warning | Sync Error |

**Widget**: `Container` with `BoxDecoration` (pill shape), `Row` with `Icon` + `Text`

---

### 3. VcsAddDialog (Modal)

**Purpose**: Multi-step form for adding a new VCS integration

**Layout**:
```
┌────────────────────────────────────────────────────┐
│ Connect to Repository                        [X]  │
├────────────────────────────────────────────────────┤
│                                                    │
│  Step 1: Select Provider                           │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌────┐ ┌────┐│
│  │GitHub│ │GitLab│ │BB Cld│ │BB Srv│ │Gitea│ │Git ││
│  └──────┘ └──────┘ └──────┘ └──────┘ └────┘ └────┘│
│                                                    │
│  Step 2: Authentication                            │
│  ┌──────────────────────────────────────────────┐  │
│  │ [OAuth 2.0]  [Token]  [SSH Key]              │  │
│  ├──────────────────────────────────────────────┤  │
│  │ Server URL: [________________] (self-hosted) │  │
│  │ Token:      [________________] (eye icon)    │  │
│  │ — OR —                                        │  │
│  │ SSH Key:    [________________] (textarea)    │  │
│  │ Passphrase: [________________] (optional)    │  │
│  └──────────────────────────────────────────────┘  │
│                                                    │
│  Step 3: Repository Selection (after auth success) │
│  Organization: [Dropdown ▼]                        │
│  Repository:   [Dropdown ▼]                        │
│  Branch Spec:  [+*: ] [main] [develop] [+ add]    │
│                                                    │
│  Step 4: Automation Settings                       │
│  ☐ Parse commits for commands                      │
│    └─ Command Executors: [Group Selector]          │
│  ☐ Silent processing                               │
│  ☐ Pull request automation                         │
│  ☐ Automatic user mapping                          │
│  Visible to: [Group Selector]                      │
│                                                    │
├────────────────────────────────────────────────────┤
│ [Test Connection]              [Cancel]  [Save]    │
└────────────────────────────────────────────────────┘
```

**Conditional Field Logic**:
| Provider | Server URL | OAuth Button | Token Field | SSH Field |
|----------|-----------|--------------|-------------|-----------|
| GitHub | Hidden | Visible | Visible | Hidden |
| GitLab | Hidden | Visible | Visible | Hidden |
| Bitbucket Cloud | Hidden | Visible | Visible | Hidden |
| Bitbucket Server | Required | Hidden | Visible | Visible |
| Gitea | Required | Hidden | Visible | Visible |
| Custom Git | Required | Hidden | Visible | Visible |

| Auth Mode | Token Field | SSH Field | Passphrase |
|-----------|-------------|-----------|------------|
| oauth | Hidden | Hidden | Hidden |
| token | Required | Hidden | Hidden |
| ssh | Hidden | Required | Optional |

**Bottom Action Bar**:
- `Test Connection`: Gray/neutral button, shows loading spinner during test
- `Save`: Primary colored, disabled until all required fields valid
- `Cancel`: Text-only button, closes dialog

---

### 4. VcsBranchSpecificationInput

**Purpose**: Tokenized input for branch ref patterns

**Behavior**:
- Default value: `+:*` (all branches)
- Type pattern + Enter/Comma → creates token chip
- Click X on chip → removes pattern
- Validation: Must match valid git ref pattern

**Widget**: `Wrap` of `Chip` widgets + `TextField` inline

**Sample Values**:
- `+:*` — watch all branches
- `+:refs/heads/main` — watch main only
- `+:refs/heads/main, +:refs/heads/develop` — watch main and develop

---

### 5. VcsUserMappingTable

**Purpose**: Display and manage manual user mapping entries

**Layout**:
```
┌──────────────────────────────────────────────────────────┐
│ User Mapping                                    [+ Add] │
├──────────────────────────────────────────────────────────┤
│ VCS Email/Username        │ YouTrack User    │ Actions   │
├──────────────────────────────────────────────────────────┤
│ alex.dev@gmail.com        │ Ahmed Hassan     │ 🗑️        │
│ sarah@gitlab.com          │ Sarah Connor     │ 🗑️        │
└──────────────────────────────────────────────────────────┘
```

**Add Entry Dialog**:
- VCS Email/Username: TextField
- YouTrack User: Dropdown (populated from project members)
- Auto-mapping indicator: ✅ icon when auto-match exists

---

### 6. VcsCommandExecutorsSection

**Purpose**: Collapsible section for selecting authorized command executors

**Visibility**: Only visible when `parse_commits_for_commands = true`

**Widget**: `ExpansionTile` with `FilterChip` multi-select for project groups

---

## Cubit Contracts

### VcsIntegrationsCubit

**State**: `VcsIntegrationsState`
```dart
sealed class VcsIntegrationsState extends Equatable {
  // Initial, Loading, Loaded(List<VcsIntegrationEntity>), Error(String)
}
```

**Events/Methods**:
| Method | Params | Side Effect |
|--------|--------|-------------|
| `loadIntegrations()` | projectId | Fetch all integrations for project |
| `addIntegration(entity)` | VcsIntegrationEntity | Insert + reload |
| `updateIntegration(entity)` | VcsIntegrationEntity | Update + reload |
| `deleteIntegration(id)` | String | Delete + reload |
| `toggleStatus(id)` | String | Toggle connected/disabled + reload |

---

### VcsIntegrationFormCubit

**State**: `VcsIntegrationFormState`
```dart
class VcsIntegrationFormState extends Equatable {
  final VcsProviderType? selectedProvider;
  final VcsAuthMode selectedAuthMode;
  final String? serverUrl;
  final String? token;
  final String? sshKey;
  final String? passphrase;
  final String? selectedOrg;
  final String? selectedRepo;
  final String branchSpec;
  final bool parseCommits;
  final bool silentProcessing;
  final bool prAutomation;
  final bool autoUserMapping;
  final List<String> commandExecutorGroups;
  final List<String> visibleToRoles;
  final bool isServerUrlRequired;   // computed from provider
  final bool isTokenFieldVisible;   // computed from authMode
  final bool isSshFieldVisible;     // computed from authMode
  final bool isFormValid;           // computed from all fields
}
```

**Methods**:
| Method | Params | Side Effect |
|--------|--------|-------------|
| `selectProvider(type)` | VcsProviderType | Update conditional fields |
| `selectAuthMode(mode)` | VcsAuthMode | Toggle token/ssh visibility |
| `updateServerUrl(url)` | String? | Validate if required |
| `updateToken(token)` | String? | Store plaintext (encrypted on save) |
| `updateSshKey(key)` | String? | Store plaintext (encrypted on save) |
| `updateBranchSpec(spec)` | String | Validate git ref pattern |
| `toggleParseCommits()` | — | Show/hide command executors |
| `testConnection()` | — | Emit testing state, call API |
| `save()` | — | Encrypt + persist to Supabase |

---

### VcsConnectionTestCubit

**State**: `VcsConnectionTestState`
```dart
sealed class VcsConnectionTestState extends Equatable {
  // Initial, Testing, Success(String message), Failure(String error)
}
```

---

### VcsUserMappingsCubit

**State**: `VcsUserMappingsState`
```dart
sealed class VcsUserMappingsState extends Equatable {
  // Initial, Loading, Loaded(List<VcsUserMappingEntity>), Error(String)
}
```

**Methods**:
| Method | Params | Side Effect |
|--------|--------|-------------|
| `loadMappings(integrationId)` | String | Fetch mappings |
| `addMapping(entity)` | VcsUserMappingEntity | Insert + reload |
| `deleteMapping(id)` | String | Delete + reload |
