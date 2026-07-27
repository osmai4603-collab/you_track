# Quickstart Validation Guide: Knowledge Base

**Date**: 2026-07-26 | **Feature**: 009-knowledge-base

## Prerequisites

- Flutter SDK installed (stable channel)
- Supabase CLI installed and linked to local instance
- Project dependencies installed (`flutter pub get`)
- Supabase migrations applied (`supabase db reset`)

---

## Validation Scenarios

### V1: Browse and Read Articles (P1)

**Setup**: Seed 5 articles in Supabase — 2 root, 2 children of root #1, 1 grandchild. Mix of `draft` and `published` statuses.

1. Run `flutter test` — all article tree tests pass
2. Launch app, navigate to a project's knowledge base
3. **Verify**: Sidebar shows collapsible tree with correct hierarchy
4. **Verify**: Clicking a parent toggles expand/collapse
5. **Verify**: Clicking an article renders formatted Markdown in main content area
6. **Verify**: Right TOC panel appears on wide screens with clickable headings
7. **Verify**: Draft articles not authored by current user are hidden

### V2: Create and Edit Articles (P1)

1. Run `flutter test` — all editor BLoC tests pass
2. Click "+ New Article" button
3. **Verify**: Editor opens with empty draft
4. Type text, apply formatting (bold, italic, heading, list, code block)
5. **Verify**: Formatting is reflected in editor
6. Wait 5 seconds without manual save
7. **Verify**: "Draft saved" indicator appears (autosave triggered)
8. Close and reopen the editor for the same article
9. **Verify**: Previously autosaved content is restored
10. Click "Publish"
11. **Verify**: Article status changes to published and appears in tree for authorized users

### V3: Hierarchy Organization (P2)

1. Create a new article, select a parent from the dropdown
2. **Verify**: New article appears nested under the parent in sidebar
3. Use drag-and-drop to reorder articles within same parent
4. **Verify**: Order persists after page reload

### V4: Inline Comments (P2)

1. Select text in a rendered article
2. **Verify**: "Add comment" context option appears
3. Type and submit a comment
4. **Verify**: Selected text is highlighted with indicator
5. Hover/tap the highlighted text
6. **Verify**: Comment thread is displayed
7. Click "Resolve" on the comment
8. **Verify**: Comment is marked resolved and highlight dims
9. Delete the comment
10. **Verify**: Comment is removed and highlight disappears

### V5: Real-time Notifications (P3)

1. Open app as User A in one browser/device
2. As User B, post a comment mentioning User A (`@username`)
3. **Verify**: User A sees notification appear within 3 seconds without refresh
4. Click the notification
5. **Verify**: User A is navigated to the article and the comment is scrolled into view

### V6: Empty and Loading States

1. Navigate to a project with no articles
2. **Verify (as admin)**: Empty state with "Create first article" CTA is shown
3. **Verify (as visitor)**: "No articles available" message is shown
4. Navigate to a project with many articles
5. **Verify**: Skeleton/shimmer loading placeholder appears while tree loads

### V7: Offline Draft Persistence (FR-010)

1. Start editing an article (autosave triggers)
2. Disable network connectivity
3. Continue editing — autosave saves to Hive locally
4. Close and reopen the app
5. **Verify**: Draft content is restored from local storage
6. Re-enable network
7. **Verify**: Draft syncs to server automatically

### V8: Search (FR-13)

1. Navigate to knowledge base with multiple articles
2. Type a search query matching article titles/content
3. **Verify**: Matching articles appear in search results
4. **Verify**: Clicking a result navigates to that article

---

## Test Commands

```bash
# Unit tests
flutter test test/features/knowledge_base/

# Widget tests
flutter test test/features/knowledge_base/presentation/

# Integration tests
flutter test integration_test/knowledge_base_test.dart

# Lint check
flutter analyze lib/features/knowledge_base/

# Build verification
flutter build apk --debug  # Android
flutter build web           # Web
```

---

## Expected Outcomes

| Scenario | Success Criteria |
|----------|-----------------|
| V1-V2 (P1) | All acceptance scenarios from User Stories 1 & 2 pass |
| V3-V4 (P2) | All acceptance scenarios from User Stories 3 & 4 pass |
| V5 (P3) | Notification delivered within 3s (SC-005) |
| V6 | Empty states role-aware; skeleton loads < 3s (SC-006) |
| V7 | 0% data loss on restart (SC-003) |
| V8 | Search returns results for valid queries |
| All | `flutter analyze` passes with no issues; `flutter test` all green |
