# Research: Knowledge Base

**Date**: 2026-07-26 | **Feature**: 009-knowledge-base

## R1: Markdown Rendering with Selectable Text

**Decision**: Use `flutter_markdown_plus` package for Markdown rendering.

**Rationale**: The spec requires selectable text for inline comments (FR-008) and a right-side table of contents extracted from headings (FR-007). `flutter_markdown_plus` supports ` selectable: true`, `onSelectionChanged` callbacks for capturing text selection ranges, and custom builders for heading elements to extract TOC data. It also handles the full Markdown subset required (headings, bold, italic, lists, code blocks, links, tables).

**Alternatives considered**:
- `markdown_widget` — good performance but less mature selectable text support
- `flutter_markdown` (official) — deprecated in favor of `flutter_markdown_plus`
- Custom `RichText` with Markdown parser — too much effort for v1

## R2: Rich Text Editor

**Decision**: Use `fleather` package for the rich text editor.

**Rationale**: `fleather` is built on top of `parchment` (Delta-based document model) and produces clean Markdown-compatible output. It provides a toolbar with standard formatting (bold, italic, headings, lists, code, links) matching the spec's FR-003 requirements. The editor is well-maintained and compatible with Flutter's latest stable.

**Alternatives considered**:
- `quill_html_editor` — produces HTML, not Markdown; would require conversion layer
- `super_editor` — more complex, lower-level; overkill for Markdown authoring
- `flutter_quill` — similar to fleather but heavier; Delta-to-Markdown conversion less clean

## R3: Offline Draft Persistence (FR-010)

**Decision**: Use `hive` with `hive_flutter` for local draft storage, plus a background sync queue.

**Rationale**: The spec requires drafts to survive app restarts and network interruptions (FR-010, edge case: connectivity loss). Hive provides fast key-value storage with no native code compilation overhead, making it ideal for caching draft content. The approach: autosave every 5 seconds to Hive locally, then attempt to sync to Supabase. If network is unavailable, queue the sync and retry on reconnection.

**Alternatives considered**:
- `isar` — more powerful but heavier; overkill for draft caching
- `sqflite` — relational DB; unnecessary complexity for key-value draft storage
- `shared_preferences` — already in project but not suited for large text blobs

## R4: Real-time Notifications via Supabase Realtime

**Decision**: Use Supabase Realtime subscriptions scoped to the `article_notifications` table, filtered by the current user's ID.

**Rationale**: The constitution (Principle III) requires realtime subscriptions to be scoped to specific tables and filtered. Supabase Realtime supports Postgres Changes which can filter on column values. We subscribe to INSERT events on `article_notifications` where `recipient_id = current_user.id`. This delivers @mention notifications within the 3s target (SC-005) and avoids unfiltered broadcast subscriptions.

**Alternatives considered**:
- Polling with Timer.periodic — simpler but higher latency; wastes bandwidth
- Firebase Cloud Messaging — external dependency; Supabase Realtime already available
- WebSocket custom implementation — reinventing the wheel; Supabase client handles this

## R5: Article Tree Construction

**Decision**: Fetch flat list of articles via Supabase query, then build tree client-side using `parent_id` references.

**Rationale**: Supabase doesn't natively support recursive tree queries (CTEs). The most practical approach for v1 (≤500 articles, SC-006) is to fetch all articles for a project in a single query ordered by `sort_order`, then construct the tree in Dart using a map of `parent_id → children`. This is O(n) and well within performance targets. The tree is built once and cached in the BLoC state; mutations trigger a局部 rebuild.

**Alternatives considered**:
- Supabase RPC with recursive CTE — more complex; harder to maintain; less portable
- Materialized path (path column) — write-time overhead; harder to reorder
- Nested sets — overkill for read-heavy v1 with simple reordering

## R6: Inline Comment Text Anchoring

**Decision**: Store the selected text string plus character offset range (start/end index within the article content).

**Rationale**: The spec requires comments anchored to specific text selections (FR-008). Storing the raw selected text plus its start/end offset in the full article content allows: (1) highlighting the anchored text when rendering, (2) handling minor content edits without breaking anchors, and (3) scrolling to the comment location. If the anchor text is no longer found (article was heavily edited), the comment falls back to showing as "orphaned" with a warning indicator.

**Alternatives considered**:
- CSS-like selectors (XPath) — too complex for Markdown content
- Paragraph + sentence index — fragile; breaks on any content edit
- Byte offset only — unreliable across Unicode content

## R7: Search Implementation (FR-013)

**Decision**: Use Supabase full-text search with `to_tsvector`/`to_tsquery` on `title` and `content_markdown` columns.

**Rationale**: The spec requires title and content search (FR-013). Supabase supports PostgreSQL full-text search natively. We create a GIN index on a generated `tsvector` column combining title and content. The Flutter client calls a Supabase RPC or uses `.textSearch()` to query. This handles Arabic and English text via PostgreSQL's built-in text search configurations.

**Alternatives considered**:
- Client-side filtering — O(n) on every keystroke; unacceptable for 500 articles
- Algolia/Elasticsearch — external service; overkill for v1 scope
- LIKE queries — slow, no ranking, no language support

## R8: Parent Article Deletion Strategy

**Decision**: Re-parent orphaned children to the deleted article's parent (or to root if deleted article was a root article).

**Rationale**: The edge case spec says child articles must NOT be silently deleted and must be re-parented or marked orphaned. Re-parenting to the grandparent is the least disruptive approach — it preserves the tree structure with minimal manual cleanup. The `sort_order` of re-parented children is adjusted to append them after the grandparent's existing children.

**Alternatives considered**:
- Mark as orphaned (no parent) — user must manually re-parent; adds friction
- Soft delete with restore — adds complexity; not in v1 scope
- Cascade delete — violates spec requirement
