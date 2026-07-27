# Feature Specification: Knowledge Base

**Feature Branch**: `009-knowledge-base`

**Created**: 2026-07-26

**Status**: Draft

**Input**: User description: "A hierarchical knowledge base system with article tree navigation, Markdown rendering, rich text editor, draft autosave, permission-based visibility, inline comments on text selection, and real-time notifications via @mentions."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse and Read Articles (Priority: P1)

As a registered user (any role), I want to browse a hierarchical tree of articles in a sidebar and read any article I have permission to see, so that I can find and consume project documentation quickly.

**Why this priority**: This is the core consumption experience. Without it, the knowledge base has no value to end users.

**Independent Test**: Can be fully tested by opening the knowledge base page, expanding tree nodes in the sidebar, clicking an article, and verifying the Markdown content renders correctly with headings, lists, code blocks, and links.

**Acceptance Scenarios**:

1. **Given** a user opens the knowledge base page, **When** the page loads, **Then** a sidebar displays a collapsible tree of article titles organized hierarchically.
2. **Given** the sidebar tree is displayed, **When** a user clicks a parent article with children, **Then** the subtree expands/collapses with animation to reveal or hide child articles.
3. **Given** the sidebar tree is displayed, **When** a user clicks an article title, **Then** the main content area renders the article's Markdown content as formatted text (headings, bold, lists, code blocks, links, tables).
4. **Given** an article is displayed, **When** the article contains headings, **Then** a table of contents panel appears on the right side (on large screens only) listing all headings for quick navigation.
5. **Given** a user clicks a heading in the table of contents, **When** the click occurs, **Then** the main content area scrolls to that heading.
6. **Given** a user lacks permission for certain articles, **When** the tree loads, **Then** those articles are hidden from the sidebar entirely.

---

### User Story 2 - Create and Edit Articles (Priority: P1)

As an admin or developer, I want to create new articles and edit existing ones using a rich text editor, so that I can author and maintain project documentation.

**Why this priority**: Content creation is essential for the knowledge base to exist. Tied with P1 reading because without content, there is nothing to read.

**Independent Test**: Can be fully tested by clicking "New Article", typing in the editor, formatting text, publishing, and verifying the article appears in the tree and renders correctly.

**Acceptance Scenarios**:

1. **Given** an admin or developer is on the knowledge base page, **When** they click the "+ New Article" button, **Then** a new draft article is created and the editor opens.
2. **Given** the editor is open, **When** the user types and formats text using the toolbar (bold, italic, headings, lists, code blocks, links), **Then** the formatting is applied and visually reflected in the editor.
3. **Given** the user is editing an article, **When** 5 seconds pass without manual save, **Then** the current content is automatically saved as a draft (autosave).
4. **Given** an autosaved draft exists, **When** the user returns to edit the same article later, **Then** the previously autosaved content is restored.
5. **Given** the user is editing an article, **When** they click "Publish", **Then** the article status changes from draft to published and it becomes visible to authorized users.
6. **Given** an admin is editing an article, **When** they change the visibility settings, **Then** the article is only shown to users with the selected roles.

---

### User Story 3 - Organize Articles in a Hierarchy (Priority: P2)

As an admin or developer, I want to nest articles under parent articles to create a logical documentation structure, so that users can navigate related topics intuitively.

**Why this priority**: Hierarchy is important for organizing content at scale, but a flat list could work for an initial launch.

**Independent Test**: Can be tested by creating a new article and choosing a parent article, then verifying it appears nested under the parent in the sidebar tree.

**Acceptance Scenarios**:

1. **Given** an admin creates a new article, **When** they select a parent article during creation, **Then** the new article appears as a child of that parent in the sidebar tree.
2. **Given** an article has child articles, **When** a user views the tree, **Then** the parent article displays a collapse/expand indicator.
3. **Given** an article is nested deeply, **When** a user views the tree, **Then** the indentation visually reflects the nesting depth.

---

### User Story 4 - Add Inline Comments (Priority: P2)

As a user, I want to highlight text within an article and add a comment anchored to that specific text, so that I can provide feedback or ask questions about specific content without leaving the page.

**Why this priority**: Inline comments enhance collaboration but are not required for basic knowledge base usage.

**Independent Test**: Can be tested by selecting text in a rendered article, submitting a comment, and verifying the comment appears linked to that text selection.

**Acceptance Scenarios**:

1. **Given** an article is displayed, **When** a user selects a portion of text, **Then** a context option appears to add a comment.
2. **Given** a user chooses to add a comment on selected text, **When** they type and submit the comment, **Then** the comment is saved and associated with the selected text anchor.
3. **Given** comments exist on an article, **When** a user views the article, **Then** annotated text segments are visually highlighted and a comment count or indicator is shown.
4. **Given** a user hovers over or taps annotated text, **When** the interaction occurs, **Then** the associated comment(s) are displayed.

---

### User Story 5 - Real-time Notifications (Priority: P3)

As a user, I want to receive a real-time notification when someone mentions me using @username in a comment, so that I stay informed without manually checking for updates.

**Why this priority**: Nice-to-have for collaboration; users can still function by manually checking comments.

**Independent Test**: Can be tested by posting a comment with @username mention and verifying the mentioned user receives a notification instantly.

**Acceptance Scenarios**:

1. **Given** a user is mentioned via @username in a comment, **When** the comment is submitted, **Then** the mentioned user sees a notification appear at the top of their screen in real time.
2. **Given** a user is not currently viewing the knowledge base, **When** they are mentioned, **Then** a notification indicator is available the next time they open the app.
3. **Given** a user receives a mention notification, **When** they click it, **Then** they are navigated to the article and the relevant comment is scrolled into view.

---

### Edge Cases

- What happens when a user loses internet connectivity while editing? The autosave must queue changes locally and sync when connectivity is restored.
- What happens when a parent article is deleted? Child articles must either be re-parented to the grandparent or marked as orphaned; they must NOT be silently deleted.
- What happens when a user tries to view an article they lack permission for? The article must not appear in the tree and direct URL access must show an "Access Denied" message.
- What happens when the article tree is very deep (10+ levels)? The sidebar must handle horizontal scrolling or collapse gracefully without breaking layout.
- What happens when two users edit the same article simultaneously? The last save wins; a conflict warning is shown if both are editing at the same time.
- What happens when Markdown content is malformed? The renderer must display what it can and show a graceful fallback for unparseable sections rather than crashing.
- What happens when an article has no headings? The right table of contents panel must be hidden entirely.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a hierarchical tree of articles in a collapsible sidebar, organized by parent-child relationships.
- **FR-001a**: System MUST show a skeleton/shimmer loading placeholder while the article tree is being fetched.
- **FR-001b**: System MUST show a dedicated empty state when no articles exist: a call-to-action for admins/developers to create the first article, and a "No articles available" message for visitors.
- **FR-002**: System MUST render article content from Markdown into formatted text including headings, bold, italic, lists, code blocks, links, and tables.
- **FR-003**: System MUST provide a rich text editor for creating and editing articles with formatting toolbar.
- **FR-004**: System MUST autosave draft content every 5 seconds while the editor is active.
- **FR-005**: System MUST support article statuses: draft and published. Drafts are only visible to the author and admins.
- **FR-006**: System MUST support role-based visibility per article (e.g., admins, developers, visitors) so that articles are only shown to authorized users.
- **FR-007**: System MUST display a table of contents on the right side of the content area (large screens only) based on article headings, with click-to-scroll navigation.
- **FR-008**: System MUST allow users to select text in a rendered article and attach a comment anchored to that text selection.
- **FR-008a**: System MUST allow the comment author or an admin to mark a comment as resolved or delete it.
- **FR-009**: System MUST deliver real-time notifications to mentioned users (@username) in comments without requiring a page refresh.
- **FR-010**: System MUST persist drafts locally so that edits survive app restarts and network interruptions.
- **FR-011**: System MUST support creating child articles nested under a parent article to build a documentation hierarchy.
- **FR-012**: System MUST allow admins to reorder articles within the tree (move up/down or drag-and-drop).
- **FR-013**: System MUST provide a search function to find articles by title or content across the knowledge base.

### Key Entities

- **Article**: A document in the knowledge base. Key attributes: unique identifier, title, Markdown content, status (draft/published), visibility roles, parent article reference, sort order (numeric, determines position among siblings), project reference, author, creation timestamp, last modified timestamp.
- **Comment**: A user remark anchored to a specific text selection within an article. Key attributes: unique identifier, article reference, author, comment text, text anchor (the selected text or position), resolved status (boolean), creation timestamp, resolved timestamp (nullable).
- **User**: A person accessing the knowledge base. Key attributes: unique identifier, display name, role(s) (admin/developer/visitor), notification preferences.
- **Notification**: A real-time alert triggered by a mention. Key attributes: unique identifier, recipient, triggering event (comment mention), article reference, read status, timestamp.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can locate and open any article in the knowledge base within 10 seconds of landing on the page.
- **SC-002**: Article content renders correctly (headings, formatting, code, tables) for 100% of valid Markdown inputs.
- **SC-003**: Draft autosave prevents data loss; 0% of user edits are lost due to network interruption or app restart when autosave is active.
- **SC-004**: Published articles are only visible to users with the correct role; 0% of restricted articles leak to unauthorized users.
- **SC-005**: Real-time @mention notifications are delivered to the recipient within 3 seconds of the comment being posted.
- **SC-006**: The knowledge base page loads and displays the article tree within 3 seconds for knowledge bases with up to 500 articles.
- **SC-007**: Users can add an inline comment on selected text in under 5 seconds (select → type → submit).
- **SC-008**: 90% of first-time users can create and publish an article without external documentation or help.

## Clarifications

### Session 2026-07-26

- Q: How should article tree ordering work when admins reorder articles (FR-012)? → A: Numeric sort_order field per article; reorder via drag-and-drop within same parent level.
- Q: What is the lifecycle of inline comments — can they be resolved or deleted? → A: Comments can be resolved (marked as addressed) and deleted by their author or an admin.
- Q: What should users see when the knowledge base has no articles or is loading? → A: Dedicated empty state with CTA for admins/developers; "No articles available" for visitors. Skeleton/shimmer loading placeholders.

## Assumptions

- The project uses Supabase as the backend (authentication, database, real-time subscriptions) per the existing constitution.
- User authentication and role management are already implemented via Supabase Auth.
- Article content is stored as Markdown text; the editor produces Markdown output.
- The knowledge base is scoped to a single project context (articles belong to a project).
- The right table of contents is only visible on screen widths >= 1024px (desktop/large tablet landscape).
- Inline comments are visible to all users who can see the article (no per-comment visibility settings in v1).
- The notification system uses Supabase Realtime for WebSocket-based delivery.
- Search functionality is limited to title and content text search (no full-text search with ranking in v1).
- File/image attachments within articles are out of scope for v1; only text-based Markdown is supported.
- Version history / edit history for articles is out of scope for v1.
