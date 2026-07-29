-- Migration: create_enum_types
-- Created: 2026-07-29

-- ============================================================
-- Issue-related enums
-- ============================================================

CREATE TYPE issue_state AS ENUM (
  'to-do',
  'in-progress',
  'done'
);

CREATE TYPE issue_priority AS ENUM (
  'show-stopper',
  'critical',
  'major',
  'normal',
  'minor'
);

CREATE TYPE issue_type AS ENUM (
  'bug',
  'cosmetic',
  'exception',
  'feature',
  'task',
  'usability-problem',
  'performance-problem',
  'epic'
);

CREATE TYPE issue_subsystem AS ENUM (
  'no-value',
  'issue-tracking',
  'project-management',
  'migration'
);

CREATE TYPE issue_link_type AS ENUM (
  'relates-to',
  'is-required-for',
  'depends-on',
  'is-duplicated-by',
  'duplicates',
  'parent-for',
  'subtask-of'
);

-- ============================================================
-- User / Project enums
-- ============================================================

CREATE TYPE user_role AS ENUM (
  'contributor',
  'project-admin',
  'system-admin'
);

-- ============================================================
-- Article enums
-- ============================================================

CREATE TYPE article_status AS ENUM (
  'draft',
  'published'
);

-- ============================================================
-- Tag enums
-- ============================================================

CREATE TYPE tag_permission_scope AS ENUM (
  'owner',
  'admin',
  'developer',
  'viewer',
  'all_members',
  'specific_users'
);

CREATE TYPE tag_permission_type AS ENUM (
  'view',
  'use',
  'edit'
);

CREATE TYPE tag_subscription_event AS ENUM (
  'updates',
  'comments',
  'tag_added',
  'spent_time',
  'issue_resolved',
  'votes',
  'tag_removed'
);

-- ============================================================
-- Custom field enums
-- ============================================================

CREATE TYPE custom_field_type AS ENUM (
  'build',
  'enum',
  'group',
  'owned-field',
  'state',
  'user',
  'version',
  'date',
  'date-time',
  'float',
  'integer',
  'string',
  'text',
  'period'
);

-- ============================================================
-- Dashboard widget enums
-- ============================================================

CREATE TYPE project_widget_type AS ENUM (
  'document-list-widget',
  'issue-list',
  'issue-distribution-report',
  'calendar-widget',
  'issue-activity-feed',
  'project-team',
  'access-eraser',
  'quick-notes',
  'report',
  'personal-time-tracking',
  'time-tracking-report',
  'work-item-exporter'
);

-- ============================================================
-- Time tracking enums
-- ============================================================

CREATE TYPE time_tracking_field_type AS ENUM (
  'text',
  'number',
  'date',
  'dropdown'
);
